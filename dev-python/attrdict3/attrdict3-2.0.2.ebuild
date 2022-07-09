# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{8..11} )
DISTUTILS_USE_SETUPTOOLS="manual"

inherit distutils-r1

DESCRIPTION="access Python object elements as both keys and attributes"
HOMEPAGE="https://pypi.org/project/attrdict3/
		https://github.com/pirofti/AttrDict3"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

DEPEND="
	$(python_gen_cond_dep 'dev-python/setuptools:python2[${PYTHON_USEDEP}]' -2)
	$(python_gen_cond_dep 'dev-python/setuptools:0[${PYTHON_USEDEP}]' -3)
"
