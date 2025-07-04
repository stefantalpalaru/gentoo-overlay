# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 pypi

DESCRIPTION="Extensions to the Python standard library unit testing framework"
HOMEPAGE="https://github.com/testing-cabal/testtools"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror"

RDEPEND="
	>=dev-python/extras-1.0.0[${PYTHON_USEDEP}]
	dev-python/python-mimeparse[${PYTHON_USEDEP}]
	>=dev-python/pbr-0.11[${PYTHON_USEDEP}]
	dev-python/pyrsistent[${PYTHON_USEDEP}]
	>=dev-python/six-1.4.0[${PYTHON_USEDEP}]
	dev-python/traceback2[${PYTHON_USEDEP}]
	>=dev-python/unittest2-1.0.0[${PYTHON_USEDEP}]
	!<dev-python/testtools-2.4.0-r200[${PYTHON_USEDEP}]
"
PDEPEND=">=dev-python/fixtures-1.3.0[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/testtools-2.4.0-py39.patch
)

distutils_enable_sphinx doc

python_test() {
	"${PYTHON}" -m testtools.run testtools.tests.test_suite || die "tests failed under ${EPYTHON}"
}
