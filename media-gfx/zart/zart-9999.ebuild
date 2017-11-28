# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic git-r3 qmake-utils

DESCRIPTION="G'MIC GUI for video streams"
HOMEPAGE="https://github.com/c-koi/zart"
EGIT_REPO_URI="https://github.com/c-koi/zart.git"

LICENSE="CeCILL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtxml:5
	media-gfx/gmic[fftw,opencv,openmp]
	media-libs/opencv
	sci-libs/fftw:3.0[threads]
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	=media-libs/cimg-9999*
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.2.1-dynamic-linking.patch
)

pkg_pretend() {
	tc-has-openmp || die "Please switch to an openmp compatible compiler"

	if ! test-flag-CXX -std=c++11 ; then
		die "You need at least GCC 4.7.x or Clang >= 3.3 for C++11-specific compiler flags"
	fi
}

src_configure() {
	eqmake5 CONFIG+=enable_dynamic_linking zart.pro
}

src_install() {
	dobin "zart"
}
