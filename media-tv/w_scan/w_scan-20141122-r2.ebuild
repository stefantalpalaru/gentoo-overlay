# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Scan for DVB-C/DVB-T/DVB-S channels without prior knowledge of frequencies and modulations"
HOMEPAGE="http://wirbel.htpc-forum.de/w_scan/index2.html"
SRC_URI="http://wirbel.htpc-forum.de/w_scan/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc examples"

DEPEND=">=virtual/linuxtv-dvb-headers-5.8"
RDEPEND=""

PATCHES=(
	"${FILESDIR}/${P}-keep-duplicate-transponders.patch"
)

src_install() {
	default

	dodoc ChangeLog README

	if use doc; then
		dodoc doc/README.file_formats doc/README_VLC_DVB
	fi

	if use examples; then
		docinto examples
		dodoc doc/rotor.conf
	fi

	ewarn "The patch from this ebuild has been developed into a fork. If you're using it, consider switching to media-tv/w_scan2"
}
