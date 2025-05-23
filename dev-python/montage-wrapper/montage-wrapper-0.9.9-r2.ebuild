# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Python wrapper for the Montage mosaicking toolkit"
HOMEPAGE="http://www.astropy.org/montage-wrapper/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="mirror !test? ( test )"

RDEPEND="
	dev-python/astropy[${PYTHON_USEDEP}]
	sci-astronomy/montage"
DEPEND="
	dev-python/astropy[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( sci-astronomy/montage )"

python_prepare_all() {
	# use system astropy-helpers instead of bundled one
	sed -i -e '/auto_use/s/True/False/' setup.cfg || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		PYTHONPATH=".." emake -C docs html
		HTML_DOCS=( docs/_build/html/. )
	fi
}

python_test() {
	esetup.py test || die "tests failed with ${EPYTHON}"
}
