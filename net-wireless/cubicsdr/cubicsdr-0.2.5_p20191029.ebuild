# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

WX_GTK_VER="3.1-gtk3"

inherit cmake-utils wxwidgets
MY_COMMIT="31323fe3c2f4ffc0d2f072f7e37ec26ebe2de609"
DESCRIPTION="Cross-Platform Software-Defined Radio Application"
HOMEPAGE="http://cubicsdr.com/"
#SRC_URI="https://github.com/cjcliffe/CubicSDR/archive/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="https://github.com/cjcliffe/CubicSDR/archive/${MY_COMMIT}.zip -> ${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bladerf hackrf plutosdr +rtlsdr uhd"

DEPEND="media-libs/rtaudio
	>net-libs/liquid-dsp-1.3.2
	>=net-wireless/soapysdr-0.4.0[bladerf?,hackrf?,plutosdr?,rtlsdr?,uhd?]
	virtual/opengl
	x11-libs/wxGTK:3.1-gtk3=[opengl]
"
RDEPEND="${DEPEND}"
#S="${WORKDIR}/CubicSDR-${PV}"
S="${WORKDIR}/CubicSDR-${MY_COMMIT}"

PATCHES=(
	"${FILESDIR}/cubicsdr-glx.patch"
)

src_prepare() {
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
