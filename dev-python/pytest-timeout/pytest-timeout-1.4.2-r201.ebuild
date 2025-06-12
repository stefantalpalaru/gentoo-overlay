# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="py.test plugin to abort hanging tests"
HOMEPAGE="https://pypi.org/project/pytest-timeout/
		https://github.com/pytest-dev/pytest-timeout"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="mirror !test? ( test )"

# do not rdepend on pytest, it won't be used without it anyway
# pytest-cov used to test compatibility
BDEPEND="
	test? (
		dev-python/pexpect[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)"
RDEPEND="
	!<dev-python/pytest-timeout-1.4.2-r200[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}"/pytest-timeout-1.4.2-optional-cov.patch
)

python_test() {
	distutils_install_for_testing

	pytest -vv || die "Tests fail with ${EPYTHON}"
}
