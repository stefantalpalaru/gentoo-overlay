# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
DISTUTILS_EXT=1

inherit distutils-r1 pypi

DESCRIPTION="Persistent/Functional/Immutable data structures"
HOMEPAGE="https://github.com/tobgu/pyrsistent/
		https://pypi.org/project/pyrsistent/"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	!<dev-python/pyrsistent-0.16.1-r200[${PYTHON_USEDEP}]
"
