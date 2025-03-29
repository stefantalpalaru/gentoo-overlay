# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 optfeature pypi

DESCRIPTION="A fast and simple micro-framework for small web-applications"
HOMEPAGE="https://pypi.org/project/bottle/
		https://bottlepy.org/
		https://github.com/bottlepy/bottle"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 ~s390 sparc x86"
IUSE="test"
RESTRICT="mirror !test? ( test )"

BDEPEND="test? ( dev-python/mako[${PYTHON_USEDEP}] )"
RDEPEND="
	!<dev-python/bottle-0.12.18-r3[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.12.8-py3.5-backport.patch
)

python_prepare_all() {
	sed -i -e '/scripts/d' setup.py || die

	# Remove test file requring connection to network
	rm test/test_server.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	# A few odd fails in the suite under pypy
	# https://github.com/bottlepy/bottle/issues/714
	"${EPYTHON}" test/testall.py || die "tests failed under ${EPYTHON}"
}

pkg_postinst() {
	optfeature "Templating support" dev-python/mako
	elog "Due to problems with bottle.py being in /usr/bin (see bug #474874)"
	elog "we do as most other distros and do not install the script anymore."
	elog "If you do want/have to call it directly rather than through your app,"
	elog "please use the following instead:"
	elog '  `python -m bottle`'
}
