# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 pypi

DESCRIPTION="HTTP library for human beings"
HOMEPAGE="https://requests.readthedocs.io/
		https://github.com/psf/requests"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa  ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="socks5 +ssl test"
RESTRICT="test"

RDEPEND="
	>=dev-python/certifi-2017.4.17:python2[${PYTHON_USEDEP}]
	>=dev-python/chardet-3.0.2:python2[${PYTHON_USEDEP}]
	<dev-python/chardet-4:python2[${PYTHON_USEDEP}]
	>=dev-python/idna-2.5:python2[${PYTHON_USEDEP}]
	<dev-python/idna-3:python2[${PYTHON_USEDEP}]
	<dev-python/urllib3-1.26[${PYTHON_USEDEP}]
	socks5? ( >=dev-python/pysocks-1.5.6:python2[${PYTHON_USEDEP}] )
	ssl? (
		>=dev-python/cryptography-1.3.4:python2[${PYTHON_USEDEP}]
	)
	!<dev-python/requests-2.24.0-r3[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/pytest-httpbin[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		>=dev-python/pysocks-1.5.6[${PYTHON_USEDEP}]
	)
"

DEPEND="${RDEPEND}
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

src_prepare() {
	distutils-r1_src_prepare

	# strip tests that require some kind of network
	sed -e 's:test_connect_timeout:_&:' \
		-e 's:test_total_timeout_connect:_&:' \
		-i tests/test_requests.py || die
	# probably pyopenssl version dependent
	sed -e 's:test_https_warnings:_&:' \
		-i tests/test_requests.py || die
	# doctests rely on networking
	sed -e 's:--doctest-modules::' \
		-i pytest.ini || die
}
