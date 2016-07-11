# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WX_GTK_VER="3.0"
MY_PV="${PV%_rc?}"

inherit cmake-utils wxwidgets

DESCRIPTION="Cross-Platform Software-Defined Radio Application"
HOMEPAGE="http://cubicsdr.com/"
SRC_URI="https://github.com/cjcliffe/CubicSDR/archive/${MY_PV}-beta-rc3.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="alsa jack oss pulseaudio +rtlsdr"

DEPEND="alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	media-libs/rtaudio
	>net-wireless/liquid-dsp-1.2.0
	>=net-wireless/soapysdr-0.4.0
	pulseaudio? ( media-sound/pulseaudio )
	rtlsdr? ( net-wireless/soapy-rtlsdr )
	virtual/opengl
	x11-libs/wxGTK:3.0[opengl]
"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	mv CubicSDR-* "${S}"
}

src_prepare() {
	rm -rf external/fftw* external/liquid-dsp
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_use alsa AUDIO_ALSA)
		$(cmake-utils_use_use jack AUDIO_JACK)
		$(cmake-utils_use_use oss AUDIO_OSS)
		$(cmake-utils_use_use pulseaudio AUDIO_PULSE)
	)
	cmake-utils_src_configure
}
