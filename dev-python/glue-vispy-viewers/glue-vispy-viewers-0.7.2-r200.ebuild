# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 virtualx

DESCRIPTION="Vispy-based viewers for Glue"
HOMEPAGE="https://github.com/glue-viz/glue-3d-viewer"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

LICENSE="BSD"
SLOT="python2"
IUSE="test"

DOCS=( README.rst CHANGES.md )

RDEPEND="
	dev-python/astropy[${PYTHON_USEDEP}]
	dev-python/glueviz[${PYTHON_USEDEP}]
	dev-python/numpy-python2[${PYTHON_USEDEP}]
	dev-python/pyopengl:python2[${PYTHON_USEDEP}]
	dev-python/QtPy:python2[${PYTHON_USEDEP},designer,gui]
	dev-python/scipy-python2[${PYTHON_USEDEP}]
	!<dev-python/glue-vispy-viewers-0.7.2-r200[${PYTHON_USEDEP}]
"

DEPEND="
	dev-python/astropy-helpers[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		  ${RDEPEND}
		  dev-python/mock[${PYTHON_USEDEP}]
		  dev-python/pytest[${PYTHON_USEDEP}]
	)
"

python_test() {
	cd "${BUILD_DIR}"/lib || die
	echo "backend: Agg" > matplotlibrc
	virtx py.test || die
}
