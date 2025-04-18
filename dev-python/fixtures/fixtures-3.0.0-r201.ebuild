# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Fixtures, reusable state for writing clean tests and more"
HOMEPAGE="https://launchpad.net/python-fixtures
		https://pypi.org/project/fixtures/
		https://github.com/testing-cabal/fixtures"
LICENSE="|| ( Apache-2.0 BSD )"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="mirror !test? ( test )"

# nose not listed but provides coverage output of tests
# run of test files by python lacks any output except on fail
RDEPEND="
	>=dev-python/pbr-0.11:python2[${PYTHON_USEDEP}]
	dev-python/six:python2[${PYTHON_USEDEP}]
	>=dev-python/testtools-0.9.22:python2[${PYTHON_USEDEP}]
	!<dev-python/fixtures-3.0.0-r3[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( dev-python/mock[${PYTHON_USEDEP}] )"

src_prepare() {
	# broken on py3.9
	# https://github.com/testing-cabal/fixtures/issues/44
	sed -i -e 's:test_patch_classmethod_with:_&:' \
		fixtures/tests/_fixtures/test_monkeypatch.py || die
	distutils-r1_src_prepare
}

python_test() {
	emake check
}
