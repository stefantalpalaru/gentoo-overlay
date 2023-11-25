# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker xdg-utils

DESCRIPTION="A Markdown Editor for the 21st century."
HOMEPAGE="https://www.zettlr.com/"
SRC_URI="https://github.com/Zettlr/Zettlr/releases/download/v${PV}/Zettlr-${PV}-amd64.deb"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="${DEPEND}
	dev-libs/expat
	net-libs/gnutls:0
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/freetype
	sys-apps/dbus
	x11-libs/gtk+:3[cups]
"

RESTRICT="mirror"
S="${WORKDIR}"

src_unpack() {
	unpack_deb ${A}
}

src_install() {
	cp -a * "${ED}/"
	ln -s zettlr "${ED}/usr/bin/Zettlr"
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
