# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WX_GTK_VER="3.0"

inherit cmake-utils wxwidgets

DESCRIPTION="Cross-Platform Software-Defined Radio Application"
HOMEPAGE="http://cubicsdr.com/"
SRC_URI="https://github.com/cjcliffe/CubicSDR/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+rtlsdr"

DEPEND="media-libs/rtaudio
	>net-wireless/liquid-dsp-1.2.0
	>=net-wireless/soapysdr-0.4.0
	rtlsdr? ( net-wireless/soapy-rtlsdr )
	virtual/opengl
	x11-libs/wxGTK:3.0[opengl]
"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	mv CubicSDR-* "${S}"
}

src_prepare() {
	epatch "${FILESDIR}/system_rtaudio.patch"
	rm -rf external/liquid-dsp external/rtaudio
	cmake-utils_src_prepare
}
