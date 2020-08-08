# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{6,7,8} )

inherit distutils-r1 virtualx

DESCRIPTION="Python tools to manipulate graphs and complex networks"
HOMEPAGE="http://networkx.github.io/ https://github.com/networkx/networkx"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="examples extras pandas scipy test xml yaml"

REQUIRED_USE="
	test? ( extras pandas scipy xml yaml )"

COMMON_DEPEND="
	$(python_gen_cond_dep '>=dev-python/matplotlib-python2-2.0.2[${PYTHON_USEDEP}]' python2_7)
	$(python_gen_cond_dep '>=dev-python/matplotlib-2.0.2[${PYTHON_USEDEP}]' 'python3*')
	extras? (
		>=dev-python/pydot-1.2.3[${PYTHON_USEDEP}]
		>=dev-python/pygraphviz-1.3.1[${PYTHON_USEDEP}]
		>=sci-libs/gdal-1.10.0[python,${PYTHON_USEDEP}]
	)
	pandas? ( >=dev-python/pandas-0.20.1[${PYTHON_USEDEP}] )
	scipy? (
		$(python_gen_cond_dep '>=sci-libs/scipy-python2-0.19[${PYTHON_USEDEP}]' python2_7)
		$(python_gen_cond_dep '>=sci-libs/scipy-0.19[${PYTHON_USEDEP}]' 'python3*')
	)
	xml? ( >=dev-python/lxml-3.7.3[${PYTHON_USEDEP}] )
	yaml? ( >=dev-python/pyyaml-3.12[${PYTHON_USEDEP}] )"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/decorator-4.1.0[${PYTHON_USEDEP}]
	${COMMON_DEPEND}
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
	)"
RDEPEND="
	>=dev-python/decorator-3.4.0[${PYTHON_USEDEP}]
	${COMMON_DEPEND}
	examples? (
		dev-python/pyparsing[${PYTHON_USEDEP}]
	)"

python_test() {
	virtx nosetests -vv || die
}

python_install_all() {
	use examples && dodoc -r examples

	distutils-r1_python_install_all
}
