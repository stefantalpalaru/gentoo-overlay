# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit twisted-r1

MY_PN="TwistedWeb"
DESCRIPTION="Twisted web server, programmable in Python"

KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="soap"
SLOT="python2"

DEPEND="
	=dev-python/twisted-core-${TWISTED_RELEASE}*:python2[${PYTHON_USEDEP}]
	dev-python/pyopenssl:python2[${PYTHON_USEDEP}]
	soap? ( dev-python/soappy:python2[${PYTHON_USEDEP}] )"
RDEPEND="${DEPEND}
	!dev-python/twisted
	!<dev-python/twisted-web-15.2.1-r200[${PYTHON_USEDEP}]
"

python_prepare_all() {
	if [[ "${EUID}" -eq 0 ]]; then
		# Disable tests failing with root permissions.
		sed -e "s/test_forbiddenResource/_&/" -i twisted/web/test/test_static.py
		sed -e "s/testDownloadPageError3/_&/" -i twisted/web/test/test_webclient.py
	fi

	distutils-r1_python_prepare_all
}
# testsuite has a PYTHONPATH oddity, currently appears to require a system install to effectively import,
# putting in question as to whether it is a testsuite
