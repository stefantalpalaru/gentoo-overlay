# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Python wrapper for healpix"
HOMEPAGE="https://github.com/healpy"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/astropy[${PYTHON_USEDEP}]
	dev-python/matplotlib:python2[${PYTHON_USEDEP}]
	dev-python/numpy:python2[${PYTHON_USEDEP}]
	sci-astronomy/healpix:=[cxx]
	sci-libs/cfitsio:="
DEPEND="${RDEPEND}
	dev-python/astropy-helpers[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/pytest-runner[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	virtual/pkgconfig
	test? (
	  dev-python/pytest[${PYTHON_USEDEP}]
	  dev-python/pytest-cython[${PYTHON_USEDEP}]
	)
"

DOCS=( README.rst CHANGELOG.rst CITATION )

python_test() {
	echo "backend: Agg" > matplotlibrc || die
	MPLCONFIGDIR=. esetup.py test || die
	rm matplotlibrc || die
}
