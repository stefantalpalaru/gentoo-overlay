# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Allows you to run a test with multiple data sets"
HOMEPAGE="https://pypi.org/project/genty/
		https://github.com/box/genty"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	!<dev-python/genty-1.3.2-r200[${PYTHON_USEDEP}]
"
DEPEND="
	test? ( dev-python/mock[${PYTHON_USEDEP}] )
"

distutils_enable_tests setup.py
