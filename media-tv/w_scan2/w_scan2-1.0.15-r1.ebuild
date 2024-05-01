# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Scan for DVB-C/DVB-T/DVB-S channels (w_scan fork)"
HOMEPAGE="https://github.com/stefantalpalaru/w_scan2"
SRC_URI="https://github.com/stefantalpalaru/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

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
