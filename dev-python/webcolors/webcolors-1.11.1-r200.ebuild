# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Color names and value formats defined by the HTML and CSS specifications"
HOMEPAGE="https://pypi.org/project/webcolors/
		https://github.com/ubernostrum/webcolors"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="python2"
LICENSE="BSD"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux"

BDEPEND="dev-python/six[${PYTHON_USEDEP}]"
RDEPEND="
	!<dev-python/webcolors-1.11.1-r200[${PYTHON_USEDEP}]
"

distutils_enable_tests nose
