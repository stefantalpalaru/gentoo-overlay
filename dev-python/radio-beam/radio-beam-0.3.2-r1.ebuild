# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="toolkit for reading/manipulating beam information from FITS headers"
HOMEPAGE="https://github.com/radio-astro-tools/radio-beam"
SRC_URI="https://github.com/radio-astro-tools/radio-beam/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

LICENSE="BSD"
SLOT="0"
IUSE="doc test"

RDEPEND="
	dev-python/astropy[${PYTHON_USEDEP}]
	dev-python/numpy-python2[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/astropy-helpers[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( <dev-python/pytest-3.7[${PYTHON_USEDEP}] )"

python_prepare_all() {
	sed -i -e '/auto_use/s/True/False/' setup.cfg || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		python_setup
		PYTHONPATH="${BUILD_DIR}"/lib \
				  esetup.py build_sphinx --no-intersphinx
	fi
}

python_test() {
	esetup.py test
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/ )
	distutils-r1_python_install_all
}
