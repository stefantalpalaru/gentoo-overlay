# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Simple module to parse ISO 8601 dates"
HOMEPAGE="https://pypi.org/project/iso8601/
		https://github.com/micktwomey/pyiso8601"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
RESTRICT="mirror test"

RDEPEND="
	!<dev-python/iso8601-0.1.13-r200[${PYTHON_USEDEP}]
"
