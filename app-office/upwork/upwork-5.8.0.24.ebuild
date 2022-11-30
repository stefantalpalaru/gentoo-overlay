# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop pax-utils rpm xdg-utils

# Binary only distribution
QA_PREBUILT="*"

DESCRIPTION="Project collaboration and tracking software for upwork.com"
HOMEPAGE="https://www.upwork.com/"
SRC_URI="
	amd64? ( https://upwork-usw2-desktopapp.upwork.com/binaries/v5_8_0_24_aef0dc8c37cf46a8/upwork-5.8.0.24-1fc24.x86_64.rpm )
	x86? ( https://upwork-usw2-desktopapp.upwork.com/binaries/v5_8_0_24_aef0dc8c37cf46a8/upwork-5.8.0.24-1fc24.i386.rpm )
"
LICENSE="ODESK"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror fetch"

S=${WORKDIR}

DEPEND=""
RDEPEND="
	dev-libs/expat
	dev-libs/nspr
	dev-libs/nss
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
	fperms 0755 /opt/Upwork/{*.node,chrome-sandbox,chrome_crashpad_handler,cmon,upwork}
	domenu usr/share/applications/upwork.desktop
	doicon usr/share/icons/hicolor/128x128/apps/upwork.png
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
