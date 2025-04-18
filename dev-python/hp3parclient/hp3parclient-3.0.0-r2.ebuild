# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="A python interface to sendfile(2) system call"
HOMEPAGE="http://packages.python.org/hp3parclient"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples test"
RESTRICT="mirror !test? ( test )"

RDEPEND=">=dev-python/httplib2-0.6.0"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/paramiko[${PYTHON_USEDEP}]
		dev-python/eventlet[${PYTHON_USEDEP}]
		test? ( dev-python/werkzeug[${PYTHON_USEDEP}]
				dev-python/nose-testconfig[${PYTHON_USEDEP}]
				dev-python/nose[${PYTHON_USEDEP}] )
		doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

# Instructions on running tests are utter nonsense.  Tried and gave up
python_compile_all() {
	use doc && emake -C docs html
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	use examples && local EXAMPLES=( samples/. )
	distutils-r1_python_install_all
}
