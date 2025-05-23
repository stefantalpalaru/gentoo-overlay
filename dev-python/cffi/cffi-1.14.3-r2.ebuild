# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 toolchain-funcs pypi

DESCRIPTION="Foreign Function Interface for Python calling C code"
HOMEPAGE="https://cffi.readthedocs.io/
		https://foss.heptapod.net/pypy/cffi/
		https://pypi.org/project/cffi/"
LICENSE="MIT"
SLOT="python2/${PV}"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="test"
RESTRICT="mirror !test? ( test )"

DEPEND="dev-libs/libffi:="
RDEPEND="${DEPEND}
	dev-python/pycparser[${PYTHON_USEDEP}]
	!<dev-python/cffi-1.14.3-r1[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

distutils_enable_sphinx doc/source

src_configure() {
	tc-export PKG_CONFIG
}

python_test() {
	"${EPYTHON}" -c "import _cffi_backend as backend" || die
	pytest -x -vv \
		--ignore testing/test_zintegration.py \
		--ignore testing/embedding \
		c/ testing/ \
		|| die "Testing failed with ${EPYTHON}"
}
