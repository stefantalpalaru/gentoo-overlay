# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

MY_PN="ZMusic"
DESCRIPTION="GZDoom's music system as a standalone library"
HOMEPAGE="https://github.com/ZDoom/ZMusic"
SRC_URI="https://github.com/ZDoom/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"
LICENSE="BSD DUMB-0.9.3 GPL-3 LGPL-2.1+ LGPL-3 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="alsa fluidsynth mpg123 +sndfile"

DEPEND="
	sys-libs/zlib
	alsa? ( media-libs/alsa-lib )
	fluidsynth? ( media-sound/fluidsynth:= )
	mpg123? ( media-sound/mpg123 )
	sndfile? ( media-libs/libsndfile )"
RDEPEND="${DEPEND}"

src_prepare() {
	rm -rf licenses || die
	cmake_src_prepare
}

src_configure() {
	# -Werror=odr
	# https://bugs.gentoo.org/860117
	# https://github.com/ZDoom/ZMusic/issues/56
	filter-lto

	local mycmakeargs=(
		-DDYN_SNDFILE=OFF
		-DDYN_MPG123=OFF
		-DCMAKE_DISABLE_FIND_PACKAGE_ALSA="$(usex !alsa)"
		-DCMAKE_DISABLE_FIND_PACKAGE_FluidSynth="$(usex !fluidsynth)"
		-DCMAKE_DISABLE_FIND_PACKAGE_MPG123="$(usex !mpg123)"
		-DCMAKE_DISABLE_FIND_PACKAGE_SndFile="$(usex !sndfile)"
		-DBUILD_SHARED_LIBS=ON
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
}
