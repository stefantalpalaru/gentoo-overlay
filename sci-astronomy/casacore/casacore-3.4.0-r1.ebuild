# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit cmake toolchain-funcs fortran-2 python-r1

DESCRIPTION="Core libraries for the Common Astronomy Software Applications"
HOMEPAGE="https://github.com/casacore/casacore"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE="+data doc fftw hdf5 openmp python +threads test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

RDEPEND="
	sci-astronomy/wcslib:0=
	sci-libs/cfitsio:0=
	sys-libs/readline:0=
	virtual/blas:=
	virtual/lapack:=
	data? ( sci-astronomy/casa-data )
	sci-libs/fftw:3.0=[threads]
	hdf5? ( sci-libs/hdf5:0= )
	python? (
		${PYTHON_DEPS}
		dev-libs/boost:0=[python,${PYTHON_USEDEP}]
		dev-python/numpy-python2[${PYTHON_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-text/doxygen )
	test? ( sci-astronomy/casa-data	)
"

pkg_pretend() {
	use openmp && tc-check-openmp
}

src_prepare() {
	cmake_src_prepare
	sed -e '/python-py/s/^.*$/find_package(Boost REQUIRED COMPONENTS python)/' \
		-i python3/CMakeLists.txt || die
}

src_configure() {
	has_version sci-libs/hdf5[mpi] && export CXX=mpicxx
	local mycmakeargs=(
		-DENABLE_SHARED=ON
		-DBUILD_PYTHON=ON
		-DPYTHON2_EXECUTABLE="${PYTHON}"
		-DDATA_DIR="${EPREFIX}/usr/share/casa/data"
		-DBUILD_TESTING="$(usex test)"
		-DUSE_HDF5="$(usex hdf5)"
		-DUSE_OPENMP="$(usex openmp)"
		-DUSE_THREADS="$(usex threads)"
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	if use doc; then
		doxygen doxygen.cfg || die
	fi
}

src_install(){
	cmake_src_install
	if use doc; then
		docinto /usr/share/doc/${PF}
		dodoc -r doc/html
		docompress -x /usr/share/doc/${PF}/html
	fi
}
