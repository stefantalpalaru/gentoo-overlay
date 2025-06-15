# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Python command line completion"
HOMEPAGE="http://codespeak.net/rlcompleter2/
		https://pypi.org/project/rlcompleter2/"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
RESTRICT="mirror"

pkg_postinst() {
	ewarn "Please read the README, and follow instructions in order to"
	ewarn "execute and configure rlcompleter2."
}
