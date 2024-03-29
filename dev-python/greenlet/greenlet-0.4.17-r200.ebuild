# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# setuptools is used only if one of the fancy commands are used
DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 flag-o-matic

DESCRIPTION="Lightweight in-process concurrent programming"
HOMEPAGE="https://pypi.org/project/greenlet/
		https://github.com/python-greenlet/greenlet"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 -hppa -ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	!<dev-python/greenlet-0.4.17-r200[${PYTHON_USEDEP}]
"

DISTUTILS_IN_SOURCE_BUILD=1

distutils_enable_sphinx doc --no-autodoc

python_compile() {
	local CFLAGS=${CFLAGS} CXXFLAGS=${CXXFLAGS}
	append-flags -fno-strict-aliasing

	distutils-r1_python_compile
}

python_test() {
	"${PYTHON}" run-tests.py -n || die "Tests fail with ${EPYTHON}"
}
