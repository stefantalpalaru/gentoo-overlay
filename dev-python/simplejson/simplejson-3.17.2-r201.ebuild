# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
DISTUTILS_EXT=1

inherit distutils-r1 pypi

DESCRIPTION="Simple, fast, extensible JSON encoder/decoder for Python"
HOMEPAGE="https://github.com/simplejson/simplejson
		https://pypi.org/project/simplejson/"
LICENSE="|| ( MIT AFL-2.1 )"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
RESTRICT="mirror test"

RDEPEND="
	!<dev-python/simplejson-3.17.2-r200[${PYTHON_USEDEP}]
"

DOCS=( README.rst CHANGES.txt )

python_compile() {
	local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"
	distutils-r1_python_compile
}
