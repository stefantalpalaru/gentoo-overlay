# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"
PYPI_PN="pyOpenSSL"
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

MY_PN=pyOpenSSL
MY_P=${MY_PN}-${PV}

DESCRIPTION="Python interface to the OpenSSL library"
HOMEPAGE="
	https://www.pyopenssl.org/
	https://pypi.org/project/pyOpenSSL/
	https://github.com/pyca/pyopenssl
"
S=${WORKDIR}/${MY_P}
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/six-1.5.2:python2[${PYTHON_USEDEP}]
	>=dev-python/cryptography-2.8:python2[${PYTHON_USEDEP}]
	!<dev-python/pyopenssl-19.1.0-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		virtual/python-cffi[${PYTHON_USEDEP}]
		dev-python/flaky[${PYTHON_USEDEP}]
		dev-python/pretend[${PYTHON_USEDEP}]
		>=dev-python/pytest-3.0.1[${PYTHON_USEDEP}]
	)"

distutils_enable_sphinx doc \
	dev-python/sphinx-rtd-theme

python_prepare_all() {
	# Requires network access
	sed -i -e 's/test_set_default_verify_paths/_&/' tests/test_ssl.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	TZ=UTC pytest -vv || die "Testing failed with ${EPYTHON}" # Fixes bug #627530
}
