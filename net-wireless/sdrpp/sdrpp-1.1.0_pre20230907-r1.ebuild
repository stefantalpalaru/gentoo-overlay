# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
CMAKE_MAKEFILE_GENERATOR="emake"
MY_COMMIT="a55d1d9c06122e25a5d5dab5d54c11dda30f2010"

inherit cmake

DESCRIPTION="a cross-platform SDR software with the aim of being bloat free and simple to use"
HOMEPAGE="https://github.com/AlexandreRouma/SDRPlusPlus"
SRC_URI="https://github.com/AlexandreRouma/SDRPlusPlus/archive/${MY_COMMIT}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/SDRPlusPlus-${MY_COMMIT}"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+rtaudio +rtlsdr soapysdr hackrf airspy plutosdr discord portaudio bladerf limesdr spyserver"
RESTRICT="mirror"

DEPEND="
	sci-libs/fftw
	media-libs/glfw
	media-libs/glew
	sci-libs/volk
	airspy? ( net-wireless/airspy )
	bladerf? ( net-wireless/bladerf )
	hackrf? ( net-libs/libhackrf )
	limesdr? ( net-wireless/limesuite )
	rtlsdr? ( net-wireless/rtl-sdr )
	soapysdr? ( net-wireless/soapysdr )
	rtaudio? ( media-libs/rtaudio )
	portaudio? ( media-libs/portaudio )
	plutosdr? (
		net-libs/libiio
		net-libs/libad9361-iio
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-plugins-prefix.patch"
	"${FILESDIR}/${PN}-portaudio_sink.patch"
	"${FILESDIR}/${PN}-installdirs.patch"
)

src_configure() {
	local mycmakeargs=(
		-DOPT_BUILD_AIRSPY_SOURCE=$(usex airspy)
		-DOPT_BUILD_AIRSPYHF_SOURCE=OFF
		-DOPT_BUILD_SOAPY_SOURCE=$(usex soapysdr)
		-DOPT_BUILD_HACKRF_SOURCE=$(usex hackrf)
		-DOPT_BUILD_PLUTOSDR_SOURCE=$(usex plutosdr)
		-DOPT_BUILD_RTL_SDR_SOURCE=$(usex rtlsdr)
		-DOPT_BUILD_AUDIO_SINK=$(usex rtaudio)
		-DOPT_BUILD_DISCORD_PRESENCE=$(usex discord)
		-DOPT_BUILD_PORTAUDIO_SINK=$(usex portaudio)
		-DOPT_BUILD_BLADERF_SOURCE=$(usex bladerf)
		-DOPT_BUILD_LIMESDR_SOURCE=$(usex limesdr)
		-DOPT_BUILD_SPYSERVER_SOURCE=$(usex spyserver)
	)

	cmake_src_configure
}
