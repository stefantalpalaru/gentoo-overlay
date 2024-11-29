# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Thin-wrapper around the mock package for easier use with pytest"
HOMEPAGE="https://github.com/pytest-dev/pytest-mock/"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ppc ppc64 ~riscv sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-python/pytest-2.7:python2[${PYTHON_USEDEP}]
	dev-python/mock:python2[${PYTHON_USEDEP}]
	!<dev-python/pytest-mock-2.0.0-r200[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

src_prepare() {
	if has_version dev-python/mock; then
		# test fails when standalone mock is installed
		sed -e 's|^\(def \)\(test_standalone_mock(\)|\1_\2|' -i tests/test_pytest_mock.py || die
	fi
	distutils-r1_src_prepare
}

python_test() {
	distutils_install_for_testing
	pytest --assert=plain -vv || die "Tests fail with ${EPYTHON}"
}
