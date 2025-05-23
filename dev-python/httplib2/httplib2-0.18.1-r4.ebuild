# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="A comprehensive HTTP client library"
HOMEPAGE="https://pypi.org/project/httplib2/
		https://github.com/httplib2/httplib2"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="test"
RESTRICT="mirror !test? ( test )"

RDEPEND="app-misc/ca-certificates
	!<dev-python/httplib2-0.18.1-r3[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
	)"

PATCHES=( "${FILESDIR}"/${PN}-0.12.1-use-system-cacerts.patch )

src_prepare() {
	sed -i -e '/--cov/d' setup.cfg || die

	# broken by using system certificates
	sed -e 's:test_certs_file_from_builtin:_&:' \
		-e 's:test_certs_file_from_environment:_&:' \
		-e 's:test_with_certifi_removed_from_modules:_&:' \
		-i tests/test_cacerts_from_env.py || die
	# broken by new PySocks, probably
	sed -e 's:test_server_not_found_error_is_raised_for_invalid_hostname:_&:' \
		-e 's:test_socks5_auth:_&:' \
		-i tests/test_proxy.py || die

	distutils-r1_src_prepare
}

python_test() {
	# tests in python* are replaced by tests/
	# upstream fails at cleaning up stuff
	pytest -vv tests || die "Tests fail with ${EPYTHON}"
}
