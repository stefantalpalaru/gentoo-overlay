# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )
CMAKE_IN_SOURCE_BUILD="1"

inherit cmake-utils git-r3 python-r1

DESCRIPTION="vendor and platform neutral SDR support library"
HOMEPAGE="https://github.com/pothosware/SoapySDR"
EGIT_REPO_URI="https://github.com/pothosware/SoapySDR.git"

LICENSE="Boost-1.0"
SLOT="0/${PV}"
KEYWORDS=""

IUSE="python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	python? ( dev-lang/swig:0 )
"

src_prepare() {
	default
	# this particular CMakeLists.txt tries to enable Python 3 behind our backs:
	sed -i -e '/BUILD_PYTHON3/d' python/CMakeLists.txt
	cmake-utils_src_prepare
	use python && python_copy_sources
}

src_configure() {
	configuration() {
		local mycmakeargs=(
			-DENABLE_PYTHON="$(usex python)"
		)

		if [ -n "${EPYTHON}" ] && python_is_python3; then
			mycmakeargs+=( -DBUILD_PYTHON3=ON )
		else
			mycmakeargs+=( -DBUILD_PYTHON3=OFF )
		fi

		CMAKE_USE_DIR="${BUILD_DIR}" cmake-utils_src_configure
	}
	use python && python_foreach_impl configuration || configuration
}

src_compile() {
	compilation() {
		CMAKE_USE_DIR="${BUILD_DIR}" cmake-utils_src_make
	}
	use python && python_foreach_impl compilation || compilation
}

src_install() {
	installation() {
		CMAKE_USE_DIR="${BUILD_DIR}" cmake-utils_src_install DESTDIR="${D}"
		use python && python_optimize
	}
	use python && python_foreach_impl installation || installation
}
