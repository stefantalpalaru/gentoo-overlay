# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

Sparse_PV="7.12.0"
Sparse_P="SuiteSparse-${Sparse_PV}"
DESCRIPTION="Extended sparse matrix package"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v${Sparse_PV}.tar.gz -> ${Sparse_P}.gh.tar.gz"
S="${WORKDIR}/${Sparse_P}/CXSparse"
LICENSE="LGPL-2.1"
SLOT="0/4"
KEYWORDS="amd64 arm arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc x86 amd64-linux x86-linux"
IUSE="static-libs"

DEPEND=">=sci-libs/suitesparseconfig-${Sparse_PV}"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_STATIC_LIBS=$(usex static-libs)
	)
	cmake_src_configure
}
