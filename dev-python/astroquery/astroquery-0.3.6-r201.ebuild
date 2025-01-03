# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 xdg-utils virtualx

DESCRIPTION="Collection of packages to access online astronomical resources"
HOMEPAGE="https://github.com/astropy/astroquery"
SRC_URI="https://github.com/astropy/astroquery/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"

DOCS=( README.rst )

PYTHON_REQ_USE="test? ( tk )"

RDEPEND="
	dev-python/astropy[${PYTHON_USEDEP}]
	dev-python/astropy-helpers[${PYTHON_USEDEP}]
	dev-python/beautifulsoup4:python2[${PYTHON_USEDEP}]
	dev-python/html5lib:python2[${PYTHON_USEDEP}]
	dev-python/keyring:python2[${PYTHON_USEDEP}]
	dev-python/numpy:python2[${PYTHON_USEDEP}]
	dev-python/requests:python2[${PYTHON_USEDEP}]
	!<dev-python/astroquery-0.3.6-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/aplpy[${PYTHON_USEDEP}]
			dev-python/pyregion[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}] )"

python_prepare_all() {
	sed -i -e '/auto_use/s/True/False/' setup.cfg || die
	xdg_environment_reset
	distutils-r1_python_prepare_all
}

python_test() {
	virtx esetup.py test
}

python_compile_all() {
	if use doc; then
		python_setup
		VARTEXFONTS="${T}"/fonts \
			MPLCONFIGDIR="${BUILD_DIR}" \
			PYTHONPATH="${BUILD_DIR}"/lib \
			esetup.py build_sphinx
	fi
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
