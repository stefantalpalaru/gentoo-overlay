# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker xdg-utils

DESCRIPTION="Comic and Manga reader, written with Node.js and using Electron"
HOMEPAGE="https://github.com/ollm/OpenComic"
SRC_URI="https://github.com/ollm/OpenComic/releases/download/v${PV}/opencomic_${PV}_amd64.deb"
S="${WORKDIR}"

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

src_unpack() {
	unpack_deb ${A}
}

src_prepare() {
	default

	find -type d -name '*musl' -print0 | xargs -r0 -- rm -rf || die
	find -type d -name '*arm64*' -print0 | xargs -r0 -- rm -rf || die
}

src_install() {
	cp -a * "${ED}/"
	dosym ../../opt/OpenComic/opencomic /usr/bin/opencomic
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
