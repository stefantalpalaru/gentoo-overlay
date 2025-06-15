# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A JavaScript Object Signing and Encryption (JOSE) implementation in Python"
HOMEPAGE="https://github.com/mpdavis/python-jose
		https://pypi.org/project/python-jose/"
# pypi tarball lacks unit tests
#SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"
SRC_URI="https://github.com/mpdavis/python-jose/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="mirror !test? ( test )"

RDEPEND="dev-python/cryptography:python2[${PYTHON_USEDEP}]
	dev-python/ecdsa:python2[${PYTHON_USEDEP}]
	dev-python/pyasn1:python2[${PYTHON_USEDEP}]
	dev-python/pycrypto[${PYTHON_USEDEP}]
	>=dev-python/pycryptodome-3.3.1:python2[${PYTHON_USEDEP}]
	dev-python/rsa:python2[${PYTHON_USEDEP}]
	dev-python/six:python2[${PYTHON_USEDEP}]
	!<dev-python/python-jose-3.1.0-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	sed -e 's|'\''pytest-runner'\'',\?||' -i setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	py.test -v || die "tests failed with ${EPYTHON}"
}
