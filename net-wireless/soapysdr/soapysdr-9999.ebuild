# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )
CMAKE_IN_SOURCE_BUILD="1"

inherit cmake-utils python-r1

DESCRIPTION="vendor and platform neutral SDR support library"
HOMEPAGE="https://github.com/pothosware/SoapySDR"

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="https://github.com/pothosware/SoapySDR.git"
	KEYWORDS=""
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/pothosware/SoapySDR/archive/soapy-sdr-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/SoapySDR-soapy-sdr-"${PV}"
fi

LICENSE="Boost-1.0"
SLOT="0/${PV}"

IUSE="bladerf hackrf python rtlsdr plutosdr uhd"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	python? ( dev-lang/swig:0 )
"
PDEPEND="bladerf? ( net-wireless/soapybladerf )
		hackrf? ( net-wireless/soapyhackrf )
		rtlsdr? ( net-wireless/soapyrtlsdr )
		plutosdr? ( net-wireless/soapyplutosdr )
		uhd? ( net-wireless/soapyuhd )"

# this complicated setup with separate Python build dirs allows building
# multiple Python versions of the bindings, unlike the utterly broken main tree
# ebuild (the 0.7.0 one always builds 2.7 and the latest 3.x bindings
# regardless of the USE flags - even with "-python")

src_prepare() {
	default
	# this particular CMakeLists.txt tries to enable Python 3 behind our backs:
	sed -i -e '/BUILD_PYTHON3/d' python/CMakeLists.txt
	cmake-utils_src_prepare
	use python && python_copy_sources
}

src_configure() {
	local commonargs=(
		-DENABLE_TESTS=OFF
		-DENABLE_DOCS=OFF
	)

	# we want the library and app here
	local mycmakeargs=(
		-DENABLE_PYTHON=OFF
		-DENABLE_APPS=ON
	)
	mycmakeargs+=( ${commonargs[@]} )
	cmake-utils_src_configure

	# now the Python bindings, in separate build dirs (we can't disable the
	# library in this configuration step, but we'll copy it during compilation)
	configuration() {
		CMAKE_USE_DIR="${BUILD_DIR}" cmake-utils_src_configure
	}

	if use python; then
		mycmakeargs=(
			-DENABLE_PYTHON=ON
			-DENABLE_APPS=OFF
		)
		mycmakeargs+=( ${commonargs[@]} )

		if [ -n "${EPYTHON}" ] && python_is_python3; then
			mycmakeargs+=( -DBUILD_PYTHON3=ON )
		else
			mycmakeargs+=( -DBUILD_PYTHON3=OFF )
		fi
		python_foreach_impl configuration
	fi
}

src_compile() {
	# library and app
	cmake-utils_src_make

	# Python bindings
	compilation() {
		# don't compile the library again
		cp -a "${S}"/lib/{lib,CMakeFiles}* "${BUILD_DIR}"/lib/
		CMAKE_USE_DIR="${BUILD_DIR}" cmake-utils_src_make
	}
	use python && python_foreach_impl compilation
}

src_install() {
	# library and app
	cmake-utils_src_install DESTDIR="${D}"

	# Python bindings
	installation() {
		CMAKE_USE_DIR="${BUILD_DIR}" cmake-utils_src_install DESTDIR="${D}"
		python_optimize
	}
	use python && python_foreach_impl installation
}
