# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils qmake-utils

DESCRIPTION="software DAB decoder for use with a dabstick, airspy or sdrplay for RPI and PC"
HOMEPAGE="http://www.sdr-j.tk/"
SRC_URI="https://github.com/JvanKatwijk/qt-dab/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_sse"

DEPEND="!media-radio/dabstick-radio
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	media-libs/faad2
	media-libs/libsamplerate
	media-libs/libsndfile
	media-libs/portaudio
	net-wireless/rtl-sdr
	sci-libs/fftw:3.0
	sys-libs/zlib
	virtual/ffmpeg
	virtual/libusb:1
	x11-libs/qwt:6[qt5]"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${P}"

src_prepare() {
	default

	sed -e 's#/usr/include/qwt#/usr/include/qwt6#g' \
		-e 's#/usr/include/qt5/qwt#/usr/include/qwt6#g' \
		-e 's#-lqwt#-lqwt6#g' \
		-e '/CONFIG\s\++= sdrplay/d' \
		-e '/CONFIG\s\++= airspy/d' \
		-i *.pro
	use cpu_flags_x86_sse && sed -i -e '/CONFIG\s\++= NO_SSE_SUPPORT/d' *.pro
}

src_configure() {
	eqmake5
}

src_install() {
	cd "${BUILD_DIR}"
	exeinto "/usr/bin"
	newexe "linux-bin/${P}-s" "${PN}"
}
