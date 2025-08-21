# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake cuda cuda-extra toolchain-funcs

Sparse_PV="7.11.0"
Sparse_P="SuiteSparse-${Sparse_PV}"
DESCRIPTION="Multithreaded multifrontal sparse QR factorization library"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v${Sparse_PV}.tar.gz -> ${Sparse_P}.gh.tar.gz"
S="${WORKDIR}/${Sparse_P}/${PN^^}"
LICENSE="GPL-2+"
SLOT="0/3"
KEYWORDS="amd64 arm arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc x86 amd64-linux x86-linux"
IUSE="cuda doc openmp static-libs"

DEPEND="
	cuda? (
		dev-util/nvidia-cuda-toolkit
		x11-drivers/nvidia-drivers
	)
	>=sci-libs/suitesparseconfig-${Sparse_PV}
	>=sci-libs/amd-3.0.3
	>=sci-libs/colamd-3.0.3
	>=sci-libs/cholmod-4.0.3
	virtual/blas"
RDEPEND="${DEPEND}"
BDEPEND="doc? ( virtual/latex-base )"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	use cuda && cuda_src_prepare
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_STATIC_LIBS=$(usex static-libs)
		-DSUITESPARSE_USE_OPENMP=$(usex openmp)
		-DSPQR_USE_CUDA=$(usex cuda)
	)

	if use cuda; then
		mycmakeargs+=(
			-DSUITESPARSE_CUDA_ARCHITECTURES="$(cuda_get_host_native_arch)"
			-DCMAKE_CUDA_HOST_COMPILER="$(cuda_gccdir)"
			-DCMAKE_CUDA_FLAGS="-forward-unknown-opts -fno-lto ${NVCCFLAGS}"
		)
	fi

	cmake_src_configure
}

src_install() {
	if use doc; then
		pushd "${S}/Doc"
		emake clean
		rm -rf *.pdf
		emake
		popd
		DOCS="${S}/Doc/*.pdf"
	fi
	cmake_src_install
}
