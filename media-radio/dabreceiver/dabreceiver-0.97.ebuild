# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils qt4-r2

DESCRIPTION="SDR-J DAB/DAB+ receiver for RTL2832-based USB sticks"
HOMEPAGE="http://www.sdr-j.tk/"
SRC_URI="http://www.sdr-j.tk/sdr-j-${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="!media-radio/dabstick-radio
	dev-qt/qtcore:4[qt3support]
	dev-qt/qtgui:4
	media-libs/faad2
	media-libs/libsamplerate
	media-libs/libsndfile
	media-libs/portaudio
	net-wireless/rtl-sdr
	sci-libs/fftw:3.0
	virtual/ffmpeg
	virtual/libusb:1
	x11-libs/qwt:6"

RDEPEND="${DEPEND}"

S="${WORKDIR}/sdr-j-${P}"

src_prepare() {
	sed -e 's#/usr/include/qwt#/usr/include/qwt6#g' \
		-e 's#-lqwt#-lqwt6#g' \
		-i *.pro
	eqmake4
}

src_install() {
	cd "${BUILD_DIR}"
	exeinto "/usr/bin"
	newexe "linux-bin/sdr-j-${P}" "${PN}"
}

