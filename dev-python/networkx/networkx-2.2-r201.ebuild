# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi virtualx

DESCRIPTION="Python tools to manipulate graphs and complex networks"
HOMEPAGE="http://networkx.github.io/
	https://github.com/networkx/networkx"
	SRC_URI="$(pypi_sdist_url "${PN}" "${PV}" .zip)"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="examples extras pandas scipy test xml yaml"

REQUIRED_USE="
	test? ( extras pandas scipy xml yaml )"

COMMON_DEPEND="
	>=dev-python/matplotlib-2.0.2:python2[${PYTHON_USEDEP}]
	extras? (
		>=dev-python/pydot-1.2.3:python2[${PYTHON_USEDEP}]
		>=dev-python/pygraphviz-1.3.1:python2[${PYTHON_USEDEP}]
		>=sci-libs/gdal-1.10.0[python,${PYTHON_USEDEP}]
	)
	pandas? ( >=dev-python/pandas-0.20.1:python2[${PYTHON_USEDEP}] )
	scipy? (
		>=dev-python/scipy-0.19:python2[${PYTHON_USEDEP}]
	)
	xml? ( >=dev-python/lxml-3.7.3:python2[${PYTHON_USEDEP}] )
	yaml? ( >=dev-python/pyyaml-3.12:python2[${PYTHON_USEDEP}] )"
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
	)
	!<dev-python/networkx-2.2-r200[${PYTHON_USEDEP}]
"
BDEPEND="
	app-arch/unzip
"

python_test() {
	virtx nosetests -vv || die
}

python_install_all() {
	use examples && dodoc -r examples

	distutils-r1_python_install_all
	mv "${ED}/usr/share/doc/${P}/"* "${ED}/usr/share/doc/${PN}-${PVR}/"
	rm -rf "${ED}/usr/share/doc/${P}"
}
