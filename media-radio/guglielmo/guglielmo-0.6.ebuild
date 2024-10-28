# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop xdg

DESCRIPTION="Qt based FM / Dab tuner"
HOMEPAGE="https://github.com/marcogrecopriolo/guglielmo"
SRC_URI="https://github.com/marcogrecopriolo/guglielmo/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"
SLOT="6"
KEYWORDS="~amd64 ~x86"
IUSE="airspy cpu_flags_x86_sse hackrf limesdr sdrplay +rtlsdr"

DEPEND="
	airspy? ( net-wireless/airspy )
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	hackrf? ( net-libs/libhackrf )
	limesdr? ( net-wireless/limesuite )
	media-libs/faad2
	media-libs/libsamplerate
	media-libs/libsndfile
	media-libs/portaudio
	rtlsdr? ( net-wireless/rtl-sdr )
	sci-libs/fftw:3.0
	sdrplay? ( net-wireless/sdrplay )
	sys-apps/lsb-release
	sys-libs/zlib
	virtual/libusb:1
	x11-libs/qwt:6
"

RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/guglielmo-0.6-gentoo.patch
)

src_configure() {
	local mycmakeargs=(
	)
	if use cpu_flags_x86_sse; then
		mycmakeargs+=(
			-DVITERBI_SSE=ON
		)
	fi
	if use airspy; then
		mycmakeargs+=(
			-DAIRSPY=ON
		)
	fi
	if use hackrf; then
		mycmakeargs+=(
			-DHACKRF=ON
		)
	fi
	if use limesdr; then
		mycmakeargs+=(
			-DLIMESDR=ON
		)
	fi
	if use rtlsdr; then
		mycmakeargs+=(
			-DRTLSDR=ON
		)
	fi
	if use sdrplay; then
		mycmakeargs+=(
			-DSDRPLAY=ON
		)
	fi
	cmake_src_configure
}

src_install() {
	doicon icons/guglielmo.ico
	domenu etc/guglielmo.desktop

	cd "${BUILD_DIR}"
	exeinto "/usr/bin"
	doexe "guglielmo"
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
