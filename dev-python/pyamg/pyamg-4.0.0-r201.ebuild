# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 flag-o-matic pypi

DESCRIPTION="Algebraic multigrid solvers in Python"
HOMEPAGE="https://pyamg.org"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/numpy:python2[${PYTHON_USEDEP}]
	dev-python/pybind11:python2[${PYTHON_USEDEP}]
	dev-python/scipy:python2[${PYTHON_USEDEP}]
	!<dev-python/pyamg-4.0.0-r3[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"
python_prepare_all() {
	append-cxxflags "-fpermissive"

	distutils-r1_python_prepare_all
}

python_test() {
	distutils_install_for_testing
	py.test -v || die
}
