# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 python3_{10..12} )

inherit python-r1

DESCRIPTION="A virtual for Python enum34 module"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-python/enum34[${PYTHON_USEDEP}]' \
	'python2*' )"
