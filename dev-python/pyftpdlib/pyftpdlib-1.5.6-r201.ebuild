# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="ssl(+)"

inherit distutils-r1 pypi

DESCRIPTION="Python FTP server library"
HOMEPAGE="https://github.com/giampaolo/pyftpdlib
		https://pypi.org/project/pyftpdlib/"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="examples ssl test"
RESTRICT="!test? ( test )"

RDEPEND="
	ssl? ( dev-python/pyopenssl[${PYTHON_USEDEP}] )
	!<dev-python/pyftpdlib-1.5.6-r200[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pyopenssl[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs dev-python/sphinx-rtd-theme

python_prepare_all() {
	mv scripts/ftpbench scripts/ftpbench_py2 || die
	sed -i \
		-e "s#scripts/ftpbench#scripts/ftpbench_py2#" \
		setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	# These tests fail when passing additional options to pytest
	# so we need to run them separately and not pass any args to pytest
	pytest ${PN}/test/test_misc.py || die "Tests failed with ${EPYTHON}"
	# Some of these tests tend to fail
	local skipped_tests=(
		# Those tests are run separately
		pyftpdlib/test/test_misc.py
		# https://github.com/giampaolo/pyftpdlib/issues/470
		# https://bugs.gentoo.org/659108
		pyftpdlib/test/test_functional_ssl.py::TestTimeouts::test_idle_data_timeout2
		pyftpdlib/test/test_functional_ssl.py::TestTimeoutsTLSMixin::test_idle_data_timeout2
		# https://github.com/giampaolo/pyftpdlib/issues/471
		# https://bugs.gentoo.org/636410
		pyftpdlib/test/test_functional.py::TestCallbacks::test_on_incomplete_file_received
		# https://github.com/giampaolo/pyftpdlib/issues/466
		# https://bugs.gentoo.org/659786
		pyftpdlib/test/test_functional_ssl.py::TestFtpListingCmdsTLSMixin::test_nlst
		# https://github.com/giampaolo/pyftpdlib/issues/512
		# https://bugs.gentoo.org/701146
		pyftpdlib/test/test_functional_ssl.py::TestFtpStoreDataTLSMixin::test_rest_on_stor
		pyftpdlib/test/test_functional_ssl.py::TestFtpStoreDataTLSMixin::test_stor_ascii
		# https://github.com/giampaolo/pyftpdlib/issues/513
		# https://bugs.gentoo.org/676232
		pyftpdlib/test/test_servers.py::TestFtpAuthentication::test_anon_auth
		# https://github.com/giampaolo/pyftpdlib/issues/513
		# https://bugs.gentoo.org/702578
		pyftpdlib/test/test_servers.py::TestFtpAuthentication::test_auth_failed
	)
	# Tests fail with TZ=GMT, see https://bugs.gentoo.org/666623
	TZ=UTC+1 pytest -vv ${skipped_tests[@]/#/--deselect } \
			|| die "Tests failed with ${EPYTHON}"
}

python_install_all() {
	if use examples; then
		docinto examples
		dodoc -r demo/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}
