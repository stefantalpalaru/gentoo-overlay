# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.1-gtk3"

inherit cmake wxwidgets
MY_COMMIT="0b2b90848de229b926703e18b53b3b9e5cd7c147"
DESCRIPTION="Cross-Platform Software-Defined Radio Application"
HOMEPAGE="http://cubicsdr.com/"
#SRC_URI="https://github.com/cjcliffe/CubicSDR/archive/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="https://github.com/cjcliffe/CubicSDR/archive/${MY_COMMIT}.zip -> ${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bladerf hackrf plutosdr +rtlsdr uhd hamlib"

DEPEND="media-libs/rtaudio
	>net-libs/liquid-dsp-1.3.2
	>=net-wireless/soapysdr-0.4.0[bladerf?,hackrf?,plutosdr?,rtlsdr?,uhd?]
	virtual/opengl
	x11-libs/wxGTK:3.1-gtk3=[opengl]
	hamlib? ( media-libs/hamlib )
"
RDEPEND="${DEPEND}"
#S="${WORKDIR}/CubicSDR-${PV}"
S="${WORKDIR}/CubicSDR-${MY_COMMIT}"

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
