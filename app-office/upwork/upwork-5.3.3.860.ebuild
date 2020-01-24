# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit rpm eutils pax-utils

# Binary only distribution
QA_PREBUILT="*"

DESCRIPTION="Project collaboration and tracking software for upwork.com"
HOMEPAGE="https://www.upwork.com/"
SRC_URI="
	amd64? ( https://updates-desktopapp.upwork.com/binaries/v5_3_3_860_wub7hae1mtgzk09u/upwork-5.3.3.860-1fc24.x86_64.rpm -> ${P}_x86_64.rpm )
	x86? ( https://updates-desktopapp.upwork.com/binaries/v5_3_3_860_wub7hae1mtgzk09u/upwork-5.3.3.860-1fc24.i386.rpm -> ${P}_i386.rpm )
"
LICENSE="ODESK"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S=${WORKDIR}
PATCHES=( "${FILESDIR}/${PN}-desktop-r1.patch" )

DEPEND=""
RDEPEND="
	dev-libs/expat
	net-libs/gnutls:0/30
	dev-libs/nettle:0/7
	dev-libs/nspr
	dev-libs/nss
	gnome-base/gconf
	media-libs/alsa-lib
	media-libs/freetype
	sys-apps/dbus
	sys-libs/libcap
	x11-libs/gtk+:3[cups]
"

src_install() {
	pax-mark m usr/share/upwork/upwork

	dobin usr/bin/upwork

	insinto /usr/share
	doins -r usr/share/upwork
	fperms 0755 /usr/share/upwork/{cmon,upwork}

	domenu usr/share/applications/upwork.desktop
	doicon usr/share/pixmaps/upwork.png
}
