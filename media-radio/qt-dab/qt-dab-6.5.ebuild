# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop xdg

DESCRIPTION="software DAB decoder for use with a dabstick, airspy or sdrplay for RPI and PC"
HOMEPAGE="http://www.sdr-j.tk/
	https://github.com/JvanKatwijk/qt-dab"
SRC_URI="https://github.com/JvanKatwijk/qt-dab/archive/refs/tags/Qt-DAB-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="6"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_sse"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	media-libs/faad2
	media-libs/libsamplerate
	media-libs/libsndfile
	media-libs/portaudio
	media-video/ffmpeg
	net-wireless/rtl-sdr
	sci-libs/fftw:3.0
	sys-libs/zlib
	virtual/libusb:1
	x11-libs/qwt:6"

RDEPEND="${DEPEND}"

S="${WORKDIR}/qt-dab-Qt-DAB-${PV}/qt-dab-${PV}"

src_prepare() {
	cd ..
	default
	cd - 2>/dev/null

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DRTLSDR_LINUX=ON
		-DRTL_TCP=ON
		-DFDK_AAC=ON
	)
	if use cpu_flags_x86_sse; then
		mycmakeargs+=(
			-DVITERBI_SSE=ON
		)
	fi
	cmake_src_configure
}

src_install() {
	doicon qt-dab-${PV}.ico
	domenu qt-dab-${PV}.desktop

	cd "${BUILD_DIR}"
	exeinto "/usr/bin"
	newexe "${P}" "${PN}-${SLOT}"
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
