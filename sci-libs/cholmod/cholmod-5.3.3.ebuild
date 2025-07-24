# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
Sparse_PV="7.10.3"
Sparse_P="SuiteSparse-${Sparse_PV}"

inherit cmake cuda toolchain-funcs

DESCRIPTION="Sparse Cholesky factorization and update/downdate library"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html
		https://github.com/DrTimothyAldenDavis/SuiteSparse"
SRC_URI="https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v${Sparse_PV}.tar.gz -> ${Sparse_P}.gh.tar.gz"
S="${WORKDIR}/${Sparse_P}/${PN^^}"
LICENSE="LGPL-2.1+ modify? ( GPL-2+ ) matrixops? ( GPL-2+ )"
SLOT="0/5"
KEYWORDS="amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="cuda +lapack +matrixops +modify openmp +partition static-libs"
RESTRICT="mirror"

BDEPEND="virtual/pkgconfig"
DEPEND="
	sci-libs/amd
	sci-libs/colamd
	>=sci-libs/suitesparseconfig-${Sparse_PV}
	cuda? (
		dev-util/nvidia-cuda-toolkit
		x11-drivers/nvidia-drivers
	)
	lapack? ( virtual/lapack )
	partition? (
		sci-libs/camd
		sci-libs/ccolamd
	)"
RDEPEND="${DEPEND}"

src_prepare() {
	use openmp && tc-check-openmp
	use cuda && cuda_src_prepare
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_STATIC_LIBS=$(usex static-libs)
		-DCHOLMOD_USE_CUDA=$(usex cuda)
		-DCHOLMOD_USE_OPENMP=$(usex openmp)
		-DCHOLMOD_MATRIXOPS=$(usex matrixops)
		-DCHOLMOD_MODIFY=$(usex modify)
		-DCHOLMOD_PARTITION=$(usex partition)
		-DCHOLMOD_CAMD=$(usex partition)
		-DCHOLMOD_SUPERNODAL=$(usex lapack)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
}
