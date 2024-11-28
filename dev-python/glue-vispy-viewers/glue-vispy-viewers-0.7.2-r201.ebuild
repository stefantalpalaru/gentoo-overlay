# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi virtualx

DESCRIPTION="Vispy-based viewers for Glue"
HOMEPAGE="https://github.com/glue-viz/glue-3d-viewer"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

DOCS=( README.rst CHANGES.md )

RDEPEND="
	dev-python/astropy[${PYTHON_USEDEP}]
	dev-python/glueviz[${PYTHON_USEDEP}]
	dev-python/numpy:python2[${PYTHON_USEDEP}]
	dev-python/pyopengl:python2[${PYTHON_USEDEP}]
	dev-python/qtpy:python2[${PYTHON_USEDEP},designer,gui]
	dev-python/scipy:python2[${PYTHON_USEDEP}]
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
