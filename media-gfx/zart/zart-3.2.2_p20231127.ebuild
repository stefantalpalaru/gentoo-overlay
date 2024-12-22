# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic qmake-utils toolchain-funcs

DESCRIPTION="G'MIC GUI for video streams"
HOMEPAGE="https://github.com/c-koi/zart"
ZART_COMMIT="d014169343f835381ad232ee11e077326561c9eb"
SRC_URI="https://github.com/c-koi/zart/archive/${ZART_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${ZART_COMMIT}"
LICENSE="CeCILL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtxml:5
	media-gfx/gmic[fftw,opencv,openmp]
	>=media-libs/opencv-4
	sci-libs/fftw:3.0[threads]
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	media-libs/cimg
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.2.2-dynamic-linking-r2.patch
)

pkg_pretend() {
	tc-check-openmp

	if ! test-flag-CXX -std=c++11 ; then
		die "You need at least GCC 4.7.x or Clang >= 3.3 for C++11-specific compiler flags"
	fi
}

src_configure() {
	# https://github.com/c-koi/zart/issues/21
	append-cxxflags -Dgmic_core
	eqmake5 GMIC_DYNAMIC_LINKING=on zart.pro
}

src_install() {
	dobin "zart"
}
