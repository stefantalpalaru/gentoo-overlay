# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="5"

MY_PN="GLee"

inherit eutils autotools

DESCRIPTION="OpenGL Easy Extension library"
HOMEPAGE="http://elf-stone.com/glee.php"
SRC_URI="http://elf-stone.com/downloads/${MY_PN}/${MY_PN}-${PV}-src.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="virtual/opengl"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-autotools.patch"
	eautoreconf || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc readme.txt extensionList.txt || die
	insinto /usr/lib/pkgconfig
	newins "${FILESDIR}/${P}.pc" glee.pc
}
