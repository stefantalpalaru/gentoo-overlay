# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="ssl(+)"

inherit distutils-r1 pypi

DESCRIPTION="HTTP library with thread-safe connection pooling, file post, and more"
HOMEPAGE="https://github.com/urllib3/urllib3"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ppc ppc64 ~riscv s390 sparc x86"
IUSE="brotli"
RESTRICT="test"

RDEPEND="
	>=dev-python/pysocks-1.5.8[${PYTHON_USEDEP}]
	<dev-python/pysocks-2.0[${PYTHON_USEDEP}]
	dev-python/certifi[${PYTHON_USEDEP}]
	>=dev-python/cryptography-1.3.4[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.14[${PYTHON_USEDEP}]
	>=dev-python/idna-2.0.0[${PYTHON_USEDEP}]
	brotli? ( dev-python/brotlipy[${PYTHON_USEDEP}] )
	!<dev-python/urllib3-1.25.10-r3[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs \
	dev-python/alabaster \
	dev-python/mock

python_prepare_all() {
	# https://github.com/urllib3/urllib3/issues/1756
	sed -e 's:10.255.255.1:240.0.0.0:' \
		-i test/__init__.py || die
	# tests failing if 'localhost.' cannot be resolved
	sed -e 's:test_dotted_fqdn:_&:' \
		-i test/with_dummyserver/test_https.py || die
	sed -e 's:test_request_host_header_ignores_fqdn_dot:_&:' \
		-i test/with_dummyserver/test_socketlevel.py || die

	distutils-r1_python_prepare_all
}
