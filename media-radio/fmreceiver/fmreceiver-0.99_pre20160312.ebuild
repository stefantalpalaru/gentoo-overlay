# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 qmake-utils

DESCRIPTION="SDR-J FM receiver for RTL2832-based USB sticks"
HOMEPAGE="http://www.sdr-j.tk/"
EGIT_REPO_URI="https://github.com/JvanKatwijk/sdr-j-fm"
EGIT_COMMIT="fd7990f14958e26e99d5170596b64ac50a54f990"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	media-libs/faad2
	media-libs/libsamplerate
	media-libs/libsndfile
	media-libs/portaudio
	net-wireless/rtl-sdr
	sci-libs/fftw:3.0
	virtual/libusb:1
	x11-libs/qwt:6[qt5]"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed -e 's#/usr/include/qwt#/usr/include/qwt6#g' \
		-e 's#/usr/include/qt5/qwt#/usr/include/qwt6#g' \
		-e 's#-lqwt#-lqwt6#g' \
		-e '/CONFIG\s\++= sdrplay/d' \
		-e '/CONFIG\s\++= airspy/d' \
		-i *.pro
}

src_configure() {
	eqmake5
}

src_install() {
	cd "${BUILD_DIR}"
	exeinto "/usr/bin"
	newexe linux-bin/sdr-j-${PN}-* "${PN}"
}
