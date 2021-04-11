# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="Extends click. Group to invoke a command without explicit subcommand name"
HOMEPAGE="https://github.com/click-contrib/click-default-group"
SRC_URI="https://github.com/click-contrib/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

RDEPEND="dev-python/click[${PYTHON_USEDEP}]
	!<dev-python/click-default-group-1.2.2-r200[${PYTHON_USEDEP}]
"
