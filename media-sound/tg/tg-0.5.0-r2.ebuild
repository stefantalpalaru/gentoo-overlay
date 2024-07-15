# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools xdg-utils

DESCRIPTION="a program for timing mechanical watches"
HOMEPAGE="https://github.com/vacaboja/tg"
SRC_URI="https://github.com/vacaboja/tg/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/glib
	media-libs/portaudio
	sci-libs/fftw:3.0
	x11-libs/gtk+:3
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	default
	eautoreconf
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
