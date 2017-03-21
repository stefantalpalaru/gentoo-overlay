# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils toolchain-funcs

MY_PN=${PN#gimp-}
MY_P=${MY_PN}-${PV}

DESCRIPTION="refocus images using FIR Wiener filtering"
HOMEPAGE="http://refocus.sourceforge.net"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+lapack"

RDEPEND="
	media-gfx/gimp:2
	lapack? ( virtual/lapack )
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

src_prepare() {
	default

	epatch "${FILESDIR}"/${MY_PN}-gimp-2.0.patch
	epatch "${FILESDIR}"/${MY_PN}-0.9.0-gimp-2.2_rlx.diff
	epatch "${FILESDIR}"/${PN}-gimp2.6.patch
	epatch "${FILESDIR}"/${PN}-atlas.patch

	eautoreconf
}

src_configure() {
	export GIMPTOOL="/usr/bin/gimptool-2.0"
	local pkgconfig=$(tc-getPKG_CONFIG)

	if use lapack; then
		econf --with-lapack-libs="$(${pkgconfig} --libs lapack)" \
		--with-lapack-includes="$(${pkgconfig} --cflags lapack)"
	else
		econf
	fi
}

src_install() {
	exeinto "$(gimptool-2.0 --gimpplugindir)/plug-ins"
	doexe src/refocus || die
}
