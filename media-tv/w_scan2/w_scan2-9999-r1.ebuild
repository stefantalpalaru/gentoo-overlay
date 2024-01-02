# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools git-r3

DESCRIPTION="Scan for DVB-C/DVB-T/DVB-S channels (w_scan fork)"
HOMEPAGE="https://github.com/stefantalpalaru/w_scan2"
EGIT_REPO_URI="https://github.com/stefantalpalaru/w_scan2"

LICENSE="GPL-2"
SLOT="0"
IUSE="doc examples"

DEPEND=">=virtual/linuxtv-dvb-headers-5.8"

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default

	dodoc ChangeLog README.md

	if use doc; then
		dodoc doc/README.file_formats doc/README_VLC_DVB
	fi

	if use examples; then
		docinto examples
		dodoc doc/rotor.conf
	fi
}
