# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Color names and value formats defined by the HTML and CSS specifications"
HOMEPAGE="https://pypi.org/project/webcolors/
		https://github.com/ubernostrum/webcolors"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror"

BDEPEND="dev-python/six[${PYTHON_USEDEP}]"
RDEPEND="
	!<dev-python/webcolors-1.11.1-r200[${PYTHON_USEDEP}]
"

distutils_enable_tests nose
