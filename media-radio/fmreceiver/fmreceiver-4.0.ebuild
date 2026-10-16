# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

DESCRIPTION="SDR-J FM receiver for RTL2832-based USB sticks"
HOMEPAGE="http://www.sdr-j.tk/ https://github.com/JvanKatwijk/sdr-j-fm"
SRC_URI="https://github.com/JvanKatwijk/sdr-j-fm/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/sdr-j-fm-${PV}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-qt/qtbase:6[gui,widgets,xml]
	dev-qt/qtcharts:6
	media-libs/faad2
	media-libs/libsamplerate
	media-libs/libsndfile
	media-libs/portaudio
	net-wireless/rtl-sdr
	sci-libs/fftw:3.0
	virtual/libusb:1
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed -i \
		-e '/+= -flto/d' \
		-e '/CONFIG\s\++= sdrplay/d' \
		-e '/CONFIG\s\++= airspy/d' \
		*.pro
}

src_configure() {
	eqmake6
}

src_install() {
	exeinto "/usr/bin"
	newexe linux-bin/${PN}-* "${PN}"
}
