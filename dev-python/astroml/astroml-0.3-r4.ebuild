# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_PN="astroML"
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi virtualx

MYPN=astroML
MYP=${MYPN}-${PV}

DESCRIPTION="Python Machine Learning library for astronomy"
HOMEPAGE="http://www.astroml.org/"
S="${WORKDIR}/${MYP}"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples test"

RDEPEND="
	dev-python/astropy[${PYTHON_USEDEP}]
	dev-python/matplotlib:python2[${PYTHON_USEDEP}]
	dev-python/numpy:python2[${PYTHON_USEDEP}]
	dev-python/scipy:python2[${PYTHON_USEDEP}]
	dev-python/scikit-learn[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

DOCS=( CHANGES.rst README.rst )

python_test() {
	virtx nosetests --verbose || die
}

python_install_all() {
	distutils-r1_python_install_all
	docinto /usr/share/doc/${PF}
	use examples && dodoc -r examples
}
