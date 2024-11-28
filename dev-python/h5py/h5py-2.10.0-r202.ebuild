# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 flag-o-matic pypi

DESCRIPTION="Simple Python interface to HDF5 files"
HOMEPAGE="http://www.h5py.org/"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test examples mpi"
RESTRICT="!test? ( test )"

RDEPEND="
	sci-libs/hdf5:0/1.10.5[mpi=,hl(+)]
	dev-python/numpy:python2[${PYTHON_USEDEP}]
	dev-python/six:python2[${PYTHON_USEDEP}]
	!<dev-python/h5py-2.10.0-r200[${PYTHON_USEDEP}]
"

DEPEND="
	${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/pkgconfig[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		dev-python/alabaster[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.3.1[${PYTHON_USEDEP}]
		)
	mpi? ( dev-python/mpi4py[${PYTHON_USEDEP}] )"

pkg_setup() {
	use mpi && export CC=mpicc
}

python_prepare_all() {
	append-cflags -fno-strict-aliasing
	distutils-r1_python_prepare_all
}

python_configure() {
	esetup.py configure $(usex mpi --mpi '')
}

python_compile_all() {
	if use doc; then
		cd "${S}"/docs || die
		sed '/html_theme/s:default:alabaster:g' -i conf.py || die
		emake html
	fi
}

python_test() {
	esetup.py test
}

python_install_all() {
	DOCS=( README.rst ANN.rst )
	use doc && HTML_DOCS=( docs/_build/html/. )
	use examples && DOCS+=( examples )

	distutils-r1_python_install_all
}
