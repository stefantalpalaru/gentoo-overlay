# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="A pyunit extension for managing expensive test resources"
HOMEPAGE="https://launchpad.net/testresources"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="mirror !test? ( test )"

DEPEND="
	dev-python/pbr[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/testtools[${PYTHON_USEDEP}]
		dev-python/fixtures[${PYTHON_USEDEP}]
	)"
RDEPEND="
	!<dev-python/testresources-2.0.1-r200[${PYTHON_USEDEP}]
"

python_prepare_all() {
	sed \
		-e 's:testBasicSortTests:_&:g' \
		-i testresources/tests/test_optimising_test_suite.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	nosetests --verbose || die "Tests failed under ${EPYTHON}"
}
