# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="The new features in unittest backported to Python 2.4+"
HOMEPAGE="https://pypi.org/project/unittest2/
		https://hg.python.org/unittest2"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
RESTRICT="mirror"

RDEPEND="
	dev-python/linecache2[${PYTHON_USEDEP}]
	>=dev-python/six-1.4[${PYTHON_USEDEP}]
	dev-python/traceback2[${PYTHON_USEDEP}]
	!<dev-python/unittest2-1.1.0-r200[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}"/remove-argparse-dependence.patch
)

python_prepare_all() {
	sed -i \
		-e 's/unit2 = unittest2.__main__:main_/unit2_py2 = unittest2.__main__:main_/' \
		setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	"${PYTHON}" -m unittest2 discover --verbose ||
		die "tests failed under ${EPYTHON}"
}
