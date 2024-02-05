# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake multilib-minimal

DESCRIPTION="Implementation of the codec specified in the JPEG-2000 Part-1 standard"
HOMEPAGE="https://www.ece.uvic.ca/~frodo/jasper/
	https://github.com/jasper-software/jasper"
SRC_URI="https://github.com/jasper-software/jasper/archive/refs/tags/version-${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

LICENSE="JasPer2.0"
SLOT="0/7"
IUSE="jpeg opengl"

RDEPEND="
	jpeg? ( media-libs/libjpeg-turbo:0[${MULTILIB_USEDEP}] )
	opengl? (
		>=virtual/opengl-7.0-r1:0[${MULTILIB_USEDEP}]
		>=media-libs/freeglut-2.8.1:0[${MULTILIB_USEDEP}]
		virtual/glu[${MULTILIB_USEDEP}]
		x11-libs/libXi[${MULTILIB_USEDEP}]
		x11-libs/libXmu[${MULTILIB_USEDEP}]
	)"
DEPEND="${RDEPEND}"

MULTILIB_WRAPPED_HEADERS=(
	"/usr/include/jasper/jas_config.h"
)

S="${WORKDIR}/jasper-version-${PV}"

multilib_src_configure() {
	local mycmakeargs=(
		-DALLOW_IN_SOURCE_BUILD=OFF
		-DBASH_PROGRAM="${EPREFIX}"/bin/bash
		-DJAS_PACKAGING=ON
		-DJAS_ENABLE_ASAN=OFF
		-DJAS_ENABLE_LSAN=OFF
		-DJAS_ENABLE_MSAN=OFF
		-DJAS_ENABLE_SHARED=ON
		-DJAS_ENABLE_DOC=OFF
		-DJAS_ENABLE_LIBHEIF=OFF
		-DJAS_INCLUDE_HEIC_CODEC=OFF

		# JPEG
		-DJAS_ENABLE_LIBJPEG=$(usex jpeg)
		-DCMAKE_DISABLE_FIND_PACKAGE_JPEG=$(usex !jpeg)

		# OpenGL
		-DJAS_ENABLE_OPENGL=$(usex opengl)
		-DCMAKE_DISABLE_FIND_PACKAGE_OpenGL=$(usex !opengl)
	)
	cmake_src_configure
}

multilib_src_compile() {
	cmake_src_compile
}

multilib_src_install() {
	cmake_src_install
}
