# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Simplifies the usage of decorators for the average programmer"
HOMEPAGE="https://github.com/micheles/decorator
		https://pypi.org/project/decorator/"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
RESTRICT="mirror"

RDEPEND="
	!<dev-python/decorator-4.4.2-r3[${PYTHON_USEDEP}]
"

DOCS=( CHANGES.md )

distutils_enable_tests setup.py
