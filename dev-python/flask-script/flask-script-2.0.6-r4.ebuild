# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
MY_PN="Flask-Script"
MY_P="${MY_PN}-${PV}"
PYPI_NO_NORMALIZE=1
PYPI_PN="${MY_PN}"

inherit distutils-r1 pypi

DESCRIPTION="Flask support for writing external scripts"
HOMEPAGE="https://flask-script.readthedocs.io/en/latest/
	https://github.com/smurfix/flask-script
	https://pypi.org/project/Flask-Script/"
S="${WORKDIR}/${MY_P}"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 x86"
IUSE="doc test"
RESTRICT="mirror !test? ( test )"

RDEPEND=">=dev-python/flask-0.10.1-r1:python2[${PYTHON_USEDEP}]
	!<dev-python/flask-script-2.0.6-r2[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

PATCHES=( "${FILESDIR}/${P}-flask_script-everywhere.patch" )

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	py.test tests.py || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
