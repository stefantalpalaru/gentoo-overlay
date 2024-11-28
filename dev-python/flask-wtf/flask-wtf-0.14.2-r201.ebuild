# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYPI_PN="Flask-WTF"
PYPI_NO_NORMALIZE=1
MY_PN="Flask-WTF"
MY_P="${MY_PN}-${PV}"

inherit distutils-r1 pypi

DESCRIPTION="Simple integration of Flask and WTForms"
HOMEPAGE="https://pythonhosted.org/Flask-WTF/
		https://pypi.org/project/Flask-WTF/"
S="${WORKDIR}/${MY_P}"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/babel:python2[${PYTHON_USEDEP}]
	dev-python/flask:python2[${PYTHON_USEDEP}]
	dev-python/flask-babel:python2[${PYTHON_USEDEP}]
	dev-python/itsdangerous:python2[${PYTHON_USEDEP}]
	dev-python/jinja2:python2[${PYTHON_USEDEP}]
	dev-python/werkzeug:python2[${PYTHON_USEDEP}]
	>=dev-python/wtforms-1.0.5:python2[${PYTHON_USEDEP}]
	!<dev-python/flask-wtf-0.14.2-r3[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
	)
	doc? (
		${RDEPEND}
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
"

python_prepare_all() {
	sed -i "/'sphinx.ext.intersphinx'/d" docs/conf.py || die
	# tries to access things over the network
	rm tests/test_recaptcha.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		sphinx-build docs docs/_build/html || die
		HTML_DOCS=( docs/_build/html/. )
	fi
}

python_test() {
	nosetests || die "tests failed with ${EPYTHON}"
}
