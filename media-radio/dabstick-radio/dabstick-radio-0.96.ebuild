# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils qt4-r2 cmake-utils

DESCRIPTION="DAB/DAB+ and wideband FM receiver for RTL2832-based USB sticks"
HOMEPAGE="http://www.sdr-j.tk/"
SRC_URI="http://www.sdr-j.tk/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtcore:4[qt3support]
	dev-qt/qtgui:4
	media-libs/faad2
	media-libs/libsndfile
	media-libs/portaudio
	net-wireless/rtl-sdr
	sci-libs/fftw:3.0
	virtual/ffmpeg
	virtual/libusb:1
	x11-libs/qwt:5"

RDEPEND="${DEPEND}"

src_prepare() {
	sed -e 's/find_package (FFTW REQUIRED)/find_path (FFTW_INCLUDES fftw3.h)\nfind_library (FFTW_LIBRARIES NAMES fftw3)/g' \
		-e 's#/usr/include/qwt#/usr/include/qwt5#g' \
		-e 's/qwt6/qwt5/g' \
		-i */CMakeLists.txt

	cat > CMakeLists.txt <<EOF
add_subdirectory("dabreceiver-V2")
add_subdirectory("fmreceiver-dab")
add_subdirectory("spectrum-viewer")
EOF
}

src_install() {
	cd "${BUILD_DIR}"
	exeinto "/usr/bin"
	doexe "dabreceiver-V2/dabreceiver-V2"
	doexe "fmreceiver-dab/fmreceiver-dab"
	doexe "spectrum-viewer/spectrum-viewer"
}

