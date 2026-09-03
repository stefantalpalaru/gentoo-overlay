# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="itch.io game browser, installer and launcher"
HOMEPAGE="https://itch.io/"
SRC_URI="https://github.com/itchio/itch/releases/download/v${PV}/itch-v${PV}-linux-amd64.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

RDEPEND="
	dev-libs/libbsd
	dev-libs/libpcre
	dev-libs/nss
	media-gfx/graphite2
	media-libs/alsa-lib
	media-libs/freetype
	media-libs/libpng:*
	media-libs/mesa
	media-libs/vulkan-loader
	net-dns/libidn2
	net-libs/gnutls
	sys-apps/util-linux
	x11-libs/gtk+:3[X,cups]
	x11-libs/libXtst
	x11-libs/libdrm
	x11-libs/libxkbcommon
	x11-libs/pixman
"

QA_PREBUILT="
	opt/itch-bin/itch
	opt/itch-bin/libvk_swiftshader.so
	opt/itch-bin/libffmpeg.so
"

src_install() {
	local destdir="${EPREFIX}/opt/${PN}"
	insinto "${destdir}"
	doins -r locales resources
	doins ./*.pak ./*.dat ./*.bin ./*.json version libvk_swiftshader.so
	doins libffmpeg.so

	exeinto "${destdir}"
	doexe itch
	dosym "../../opt/${PN}/itch" /usr/bin/itch-bin

	newicon -s 256 "resources/app/src/static/images/tray/itch.png" "${PN}.png"
	newicon -s 128 "resources/app/src/static/images/window/itch/icon.png" "${PN}.png"

	make_desktop_entry itch-bin Itch itch-bin "Network;Game"
}
