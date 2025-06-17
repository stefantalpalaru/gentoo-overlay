# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A small convenience library for fetching files securely"
HOMEPAGE="https://github.com/dol-sen/ssl-fetch"
SRC_URI="https://github.com/dol-sen/ssl-fetch/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="GPL-2"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
RESTRICT="mirror"

RDEPEND="${DEPEND}
	>=dev-python/requests-1.2.1[${PYTHON_USEDEP}]
	!<dev-python/ssl-fetch-0.4-r200[${PYTHON_USEDEP}]
"

pkg_postinst() {
	echo
	elog "This is beta software."
	elog "The APIs it installs should be considered unstable"
	elog "and are subject to change in these early versions."
	elog
	elog "Please file any enhancement requests, or bugs"
	elog "at https://github.com/dol-sen/ssl-fetch/issues"
	elog "I am also on IRC @ #gentoo-portage, #gentoo-keys,... of the Freenode network"
	echo
}
