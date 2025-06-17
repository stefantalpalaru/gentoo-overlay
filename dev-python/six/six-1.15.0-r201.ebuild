# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Python 2 and 3 compatibility library"
HOMEPAGE="https://github.com/benjaminp/six
		https://pypi.org/project/six/"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
RESTRICT="mirror test"

distutils_enable_sphinx documentation --no-autodoc

RDEPEND="
	!<dev-python/six-1.15.0-r200[${PYTHON_USEDEP}]
"
