# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 cmake-utils

DESCRIPTION="Advanced drum machine"
HOMEPAGE="http://www.hydrogen-music.org"
EGIT_REPO_URI="git://github.com/hydrogen-music/hydrogen.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="alsa debug jack jacksession ladspa lash lrdf portaudio portmidi rubberband"

RDEPEND="
	alsa? ( media-libs/alsa-lib )
	app-arch/libarchive
	dev-libs/libxml2
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtxmlpatterns:4
	jack? ( virtual/jack )
	ladspa? ( media-libs/liblrdf )
	lash? ( media-sound/lash )
	lrdf? ( media-libs/liblrdf )
	media-libs/audiofile
	media-libs/libsndfile
	media-libs/rubberband
	portaudio? ( >=media-libs/portaudio-18.1 )
	portmidi? ( media-libs/portmidi )
"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog DEVELOPERS README.txt )

src_prepare() {
	default
	sed -i -e 's/-O2//' CMakeLists.txt
}

src_configure() {
	local mycmakeargs=(${mycmakeargs}
		-DWANT_ALSA="$(usex alsa)"
		-DWANT_DEBUG="$(usex debug)"
		-DWANT_JACK="$(usex jack)"
		-DWANT_JACKSESSION="$(usex jacksession)"
		-DWANT_LADSPA="$(usex ladspa)"
		-DWANT_LASH="$(usex lash)"
		-DWANT_LRDF="$(usex lrdf)"
		-DWANT_PORTAUDIO="$(usex portaudio)"
		-DWANT_PORTMIDI="$(usex portmidi)"
		-DWANT_RUBBERBAND="$(usex rubberband)"
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	doicon "${S}/data/img/gray/h2-icon.svg"
}
