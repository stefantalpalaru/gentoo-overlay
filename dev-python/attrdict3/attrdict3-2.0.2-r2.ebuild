# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 python3_{10..12} )
DISTUTILS_USE_SETUPTOOLS="manual"

inherit distutils-r1 pypi

DESCRIPTION="access Python object elements as both keys and attributes"
HOMEPAGE="https://pypi.org/project/attrdict3/
		https://github.com/pirofti/AttrDict3"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
RESTRICT="mirror"

DEPEND="
	$(python_gen_cond_dep 'dev-python/setuptools:python2[${PYTHON_USEDEP}]' -2)
	$(python_gen_cond_dep 'dev-python/setuptools:0[${PYTHON_USEDEP}]' -3)
"
RDEPEND="${PYTHON_DEPS}"
