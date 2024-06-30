# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# The order is important here! Both, cmake and xdg define src_prepare.
# We need the one from cmake
inherit bash-completion-r1 cmake git-r3 xdg

DESCRIPTION="Cross-platform music production software"
HOMEPAGE="https://lmms.io"
EGIT_REPO_URI="https://github.com/LMMS/lmms.git"
LICENSE="GPL-2 LGPL-2"
SLOT="0"
IUSE="alsa carla debug fluidsynth jack libgig mp3 ogg portaudio pulseaudio sdl soundio stk vst"

COMMON_DEPEND="
	>=media-libs/libsamplerate-0.1.8
	>=media-libs/libsndfile-1.0.11
	>=x11-libs/fltk-1.3.0_rc3:1
	alsa? ( media-libs/alsa-lib )
	carla? ( media-sound/carla )
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qttest:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	fluidsynth? ( media-sound/fluidsynth )
	jack? ( virtual/jack )
	libgig? ( media-libs/libgig )
	mp3? ( media-sound/lame )
	ogg? (
		media-libs/libogg
		media-libs/libvorbis
	)
	portaudio? ( >=media-libs/portaudio-19_pre )
	pulseaudio? ( media-libs/libpulse )
	sci-libs/fftw:3.0
	sdl? (
		>=media-libs/sdl-sound-1.0.1
		media-libs/libsdl
	)
	soundio? ( media-libs/libsoundio )
	stk? ( media-libs/stk )
	sys-libs/zlib
	vst? (
		dev-qt/qtx11extras:5
		virtual/wine
	)
"
DEPEND="${COMMON_DEPEND}
"
BDEPEND="
	dev-qt/linguist-tools:5
"
RDEPEND="${COMMON_DEPEND}
	media-plugins/calf
	media-plugins/caps-plugins
	media-plugins/cmt-plugins
	media-plugins/swh-plugins
	media-plugins/tap-plugins
"

DOCS=( README.md doc/AUTHORS )

src_configure() {
	local mycmakeargs+=(
		-DBASHCOMP_PKG_PATH="$(get_bashcompdir)"
		-DUSE_WERROR=FALSE
		-DWANT_ALSA=$(usex alsa)
		-DWANT_CALF=FALSE
		-DWANT_CAPS=FALSE
		-DWANT_CARLA=$(usex carla)
		-DWANT_CMT=FALSE
		-DWANT_GIG=$(usex libgig)
		-DWANT_JACK=$(usex jack)
		-DWANT_MP3LAME=$(usex mp3)
		-DWANT_OGGVORBIS=$(usex ogg)
		-DWANT_PORTAUDIO=$(usex portaudio)
		-DWANT_PULSEAUDIO=$(usex pulseaudio)
		-DWANT_SDL=$(usex sdl)
		-DWANT_SF2=$(usex fluidsynth)
		-DWANT_SOUNDIO=$(usex soundio)
		-DWANT_STK=$(usex stk)
		-DWANT_SWH=FALSE
		-DWANT_TAP=FALSE
		-DWANT_VST=$(usex vst)
		-DWANT_WEAKJACK=FALSE
	)
	cmake_src_configure
}
