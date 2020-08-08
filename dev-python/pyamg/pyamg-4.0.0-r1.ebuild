# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Algebraic multigrid solvers in Python"
HOMEPAGE="https://pyamg.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	$(python_gen_cond_dep 'dev-python/numpy-python2[${PYTHON_USEDEP}]' python2_7)
	$(python_gen_cond_dep 'dev-python/numpy[${PYTHON_USEDEP}]' 'python3*')
	dev-python/pybind11[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'sci-libs/scipy-python2[${PYTHON_USEDEP}]' python2_7)
	$(python_gen_cond_dep 'sci-libs/scipy[${PYTHON_USEDEP}]' 'python3*')
"
DEPEND="${RDEPEND}
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

python_test() {
	distutils_install_for_testing
	py.test -v || die
}
