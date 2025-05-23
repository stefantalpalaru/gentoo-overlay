# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"
DISTUTILS_EXT=1

inherit distutils-r1 pypi

DESCRIPTION="A self-contained cryptographic library for Python"
HOMEPAGE="https://www.pycryptodome.org
		https://github.com/Legrandin/pycryptodome
		https://pypi.org/project/pycryptodome/"
LICENSE="BSD-2 Unlicense"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
RESTRICT="mirror"

RDEPEND="dev-libs/gmp:0
	virtual/python-cffi[${PYTHON_USEDEP}]
	!dev-python/pycrypto
	!<dev-python/pycryptodome-3.9.8-r200[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/pycryptodome-3.9.4-parallel-make.patch"
)

distutils_enable_tests setup.py

python_prepare_all() {
	# parallel make fixes
	#  Multiple targets were compiling the same file, setuptools doesn't
	#  understand this and you get race conditions where a file gets
	#  overwritten while it's linking. This makes the files look like separate
	#  files so this race won't happen
	ln src/blowfish.c src/blowfish_eks.c || die
	ln src/mont.c src/mont_math.c || die

	distutils-r1_python_prepare_all
}
