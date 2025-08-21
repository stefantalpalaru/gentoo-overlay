# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs

Sparse_PV=$(ver_rs 3 '.')
Sparse_P="SuiteSparse-${Sparse_PV}"
DESCRIPTION="Common configurations for all packages in suitesparse"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v${Sparse_PV}.tar.gz -> ${Sparse_P}.gh.tar.gz"
S="${WORKDIR}/${Sparse_P}/SuiteSparse_config"
LICENSE="BSD"
SLOT="0/7"
KEYWORDS="amd64 arm arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86 amd64-linux x86-linux"
IUSE="openmp static-libs"

# BLAS availability is checked for at configuration time and will fail if it is not present.
BDEPEND="virtual/blas"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
	# Make sure we always include the Fortran interface.
	# It doesn't require a Fortran compiler to be present
	# and simplifies the configuration for dependencies.
	local mycmakeargs=(
		-DBUILD_STATIC_LIBS=$(usex static-libs)
		-DSUITESPARSE_USE_FORTRAN=ON
		-DSUITESPARSE_USE_OPENMP=$(usex openmp)
	)
	cmake_src_configure
}
