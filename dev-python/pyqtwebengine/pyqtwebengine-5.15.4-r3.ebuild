# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 python3_{10..12} )
PYPI_PN="PyQtWebEngine"
PYPI_NO_NORMALIZE=1

inherit pypi python-r1 qmake-utils

DESCRIPTION="Python bindings for QtWebEngine"
HOMEPAGE="https://www.riverbankcomputing.com/software/pyqtwebengine/intro"

MY_P=${PYPI_PN}-${PV/_pre/.dev}

S=${WORKDIR}/${MY_P}
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="debug"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-python/pyqt5-5.14[gui,network,printsupport,ssl,webchannel,widgets,${PYTHON_USEDEP}]
	$(python_gen_cond_dep '>=dev-python/pyqt5-sip-4.19.22:python2=[${PYTHON_USEDEP}]' -2)
	$(python_gen_cond_dep '>=dev-python/pyqt5-sip-4.19.22:0=[${PYTHON_USEDEP}]' -3)
	dev-qt/qtcore:5
	dev-qt/qtwebengine:5[widgets]
"
DEPEND="${RDEPEND}
	>=dev-python/sip-4.19.22[${PYTHON_USEDEP}]
"

src_prepare() {
	sed -i \
		-e 's/, exist_ok=True//' \
		configure.py || die
	default
}

src_configure() {
	configuration() {
		local myconf=(
			"${PYTHON}"
			"${S}"/configure.py
			--qmake="$(qt5_get_bindir)"/qmake
			$(usex debug '--debug --trace' '')
			--verbose
		)
		if ! python_is_python3; then
			myconf+=(
				--sip=/usr/bin/sip
			)
		fi
		echo "${myconf[@]}"
		"${myconf[@]}" || die

		# Fix parallel install failure
		sed -i -e '/INSTALLS += distinfo/i distinfo.depends = install_subtargets install_pep484_stubs install_api' \
			${PN}.pro || die

		# Run eqmake to respect toolchain and build flags
		eqmake5 -recursive ${PN}.pro
	}
	python_foreach_impl run_in_build_dir configuration
}

src_compile() {
	python_foreach_impl run_in_build_dir default
}

src_install() {
	installation() {
		emake INSTALL_ROOT="${D}" install
		python_optimize
	}
	python_foreach_impl run_in_build_dir installation

	einstalldocs
}
