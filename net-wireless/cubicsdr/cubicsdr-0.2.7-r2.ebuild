# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.2-gtk3"

inherit cmake wxwidgets
DESCRIPTION="Cross-Platform Software-Defined Radio Application"
HOMEPAGE="http://cubicsdr.com/"
SRC_URI="https://github.com/cjcliffe/CubicSDR/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/CubicSDR-${PV}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bladerf hackrf plutosdr +rtlsdr uhd hamlib airspyhf"

DEPEND="media-libs/rtaudio
	>=net-libs/liquid-dsp-1.4.0
	>=net-wireless/soapysdr-0.4.0[bladerf?,hackrf?,plutosdr?,rtlsdr?,uhd?,airspyhf?]
	virtual/opengl
	x11-libs/wxGTK:${WX_GTK_VER}=[opengl]
	hamlib? ( media-libs/hamlib )
"
RDEPEND="${DEPEND}"

src_prepare() {
	rm -rf external/liquid-dsp external/rtaudio
	cmake_src_prepare
}

src_configure() {
	setup-wxwidgets
	local mycmakeargs=(
		-DUSE_SYSTEM_RTAUDIO=ON
		-DUSE_HAMLIB=$(usex hamlib ON OFF)
	)
	cmake_src_configure
}
