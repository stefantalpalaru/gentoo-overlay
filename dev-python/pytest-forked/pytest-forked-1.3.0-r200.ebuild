# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="run tests in isolated forked subprocesses"
HOMEPAGE="https://pypi.org/project/pytest-forked/
		https://github.com/pytest-dev/pytest-forked"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="python2"
LICENSE="MIT"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv s390 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

# Please do not RDEPEND on pytest; this package won't do anything
# without pytest installed, and there is no reason to force older
# implementations on pytest.
RDEPEND="
	dev-python/py[${PYTHON_USEDEP}]
	!<dev-python/pytest-forked-1.3.0-r200[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		>=dev-python/pytest-3.10[${PYTHON_USEDEP}]
	)"

python_test() {
	distutils_install_for_testing
	pytest -vv -p no:flaky || die "Tests failed under ${EPYTHON}"
}
