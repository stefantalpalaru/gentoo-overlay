# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

WX_GTK_VER="3.1-gtk3"

inherit cmake-utils wxwidgets

DESCRIPTION="Cross-Platform Software-Defined Radio Application"
HOMEPAGE="http://cubicsdr.com/"
SRC_URI="https://github.com/cjcliffe/CubicSDR/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+rtlsdr"

DEPEND="media-libs/rtaudio
	>net-libs/liquid-dsp-1.2.0
	>=net-wireless/soapysdr-0.4.0
	rtlsdr? ( net-wireless/soapy-rtlsdr )
	virtual/opengl
	x11-libs/wxGTK:3.1-gtk3[opengl]
"
RDEPEND="${DEPEND}"
S="${WORKDIR}/CubicSDR-${PV}"

src_prepare() {
	default

	rm -rf external/liquid-dsp external/rtaudio
	cmake-utils_src_prepare
}

src_configure() {
	setup-wxwidgets
	local mycmakeargs=(
	-DUSE_SYSTEM_RTAUDIO=ON
	)
	cmake-utils_src_configure
}
