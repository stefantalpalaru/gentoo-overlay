# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6..9} )

inherit distutils-r1

DESCRIPTION="Fast NumPy array functions written in Cython"
HOMEPAGE="https://pypi.org/project/Bottleneck/"
SRC_URI="https://github.com/kwgoodman/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	$(python_gen_cond_dep '>=dev-python/numpy-python2-1.9.1[${PYTHON_USEDEP}]' python2_7)
	$(python_gen_cond_dep '>=dev-python/numpy-1.9.1[${PYTHON_USEDEP}]' 'python3*')
	$(python_gen_cond_dep 'dev-python/scipy-python2[${PYTHON_USEDEP}]' python2_7)
	$(python_gen_cond_dep 'dev-python/scipy[${PYTHON_USEDEP}]' 'python3*')
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose )"

python_test() {
	${EPYTHON} ./tools/test-installed-bottleneck.py
}
