# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

WX_GTK_VER="3.0"

inherit cmake-utils git-r3 wxwidgets

DESCRIPTION="Cross-Platform Software-Defined Radio Application"
HOMEPAGE="http://cubicsdr.com/"
EGIT_REPO_URI="https://github.com/cjcliffe/CubicSDR.git"
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
	x11-libs/wxGTK:3.0[opengl]
"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	rm -rf external/liquid-dsp external/rtaudio
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
	-DUSE_SYSTEM_RTAUDIO=ON
	)
	cmake-utils_src_configure
}
