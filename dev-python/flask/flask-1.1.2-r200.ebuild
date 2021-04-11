# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A microframework based on Werkzeug, Jinja2 and good intentions"
HOMEPAGE="https://github.com/pallets/flask/"
MY_PN="Flask"
MY_P="${MY_PN}-${PV}"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
LICENSE="BSD"
SLOT="python2"
IUSE="examples test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/click:python2[${PYTHON_USEDEP}]
	dev-python/blinker:python2[${PYTHON_USEDEP}]
	dev-python/itsdangerous:python2[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.10:python2[${PYTHON_USEDEP}]
	>=dev-python/werkzeug-0.15:python2[${PYTHON_USEDEP}]
	!<dev-python/flask-1.1.2-r3[${PYTHON_USEDEP}]
"
DEPEND="
	test? (
		${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
	)"
S="${WORKDIR}/${MY_P}"

distutils_enable_sphinx docs

python_prepare_all() {
	sed -i \
		-e 's/"flask = flask.cli:main"/"flask_py2 = flask.cli:main"/' \
		setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	PYTHONPATH=${S}/examples/flaskr:${S}/examples/minitwit${PYTHONPATH:+:${PYTHONPATH}} \
		pytest -vv -p no:httpbin || die "Testing failed with ${EPYTHON}"
}

python_install_all() {
	use examples && dodoc -r examples

	distutils-r1_python_install_all
}
