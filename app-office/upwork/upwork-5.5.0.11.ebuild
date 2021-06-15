# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils pax-utils rpm

# Binary only distribution
QA_PREBUILT="*"

DESCRIPTION="Project collaboration and tracking software for upwork.com"
HOMEPAGE="https://www.upwork.com/"
SRC_URI="
	amd64? ( https://upwork-usw2-desktopapp.upwork.com/binaries/v5_5_0_11_61df9c99b6df4e7b/upwork-5.5.0.11-1fc24.x86_64.rpm -> ${P}_x86_64.rpm )
	x86? ( https://upwork-usw2-desktopapp.upwork.com/binaries/v5_5_0_11_61df9c99b6df4e7b/upwork-5.5.0.11-1fc24.i386.rpm -> ${P}_i386.rpm )
"
LICENSE="ODESK"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S=${WORKDIR}

DEPEND=""
RDEPEND="
	dev-libs/expat
	net-libs/gnutls:0/30
	dev-libs/nspr
	dev-libs/nss
	gnome-base/gconf
	media-libs/alsa-lib
	media-libs/freetype
	sys-apps/dbus
	sys-libs/libcap
	x11-libs/gtk+:3[cups]
	x11-libs/libXinerama
	x11-libs/libXScrnSaver
	x11-libs/libXtst
"

src_prepare() {
	default

	# Generate an executable
	mkdir -p usr/bin
	cat <<-EOF > usr/bin/upwork || die
	#!/bin/sh
	"${EPREFIX}/opt/Upwork/upwork" \$@
	EOF
}

src_install() {
	pax-mark m usr/share/upwork/upwork

	dobin usr/bin/upwork
	insinto /usr
	doins -r usr/share
	insinto /opt
	doins -r opt/Upwork
	fperms 0755 /opt/Upwork/{app.node,cmon,upwork}
	domenu usr/share/applications/upwork.desktop
	doicon usr/share/icons/hicolor/128x128/apps/upwork.png
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
