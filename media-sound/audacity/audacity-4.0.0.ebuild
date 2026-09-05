# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.2-gtk3"
MY_P="Audacity-${PV}"

inherit cmake flag-o-matic virtualx wxwidgets xdg

DESCRIPTION="Free crossplatform audio editor"
HOMEPAGE="https://www.audacityteam.org/"
SRC_URI="https://github.com/audacity/audacity/releases/download/Audacity-${PV}/audacity-sources-${PV}.tar.xz"
S="${WORKDIR}/audacity-${PV}"
# GPL-2+, GPL-3 - Audacity itself
# CC-BY-3.0 - Documentation
LICENSE="GPL-2+
	GPL-3
	audiocom? ( ZLIB )
"
SLOT="0"
# >=3.6 versions are too buggy
# 4.x versions are alpha quality
#KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="alsa audiocom ffmpeg +flac id3tag +ladspa +lv2 mpg123 +ogg
	opus +portmixer sbsms test twolame vamp +vorbis wavpack"
REQUIRED_USE="
	opus? ( ogg )
	vorbis? ( ogg )
"
RESTRICT="!test? ( test ) network-sandbox"

# dev-db/sqlite:3 hard dependency.
# sys-apps/util-linux hard dependency, from cmake-proxies/CMakeLists.txt
#   for libuuid
# portmidi became non-optional: building without it results in build
#   failures, even with some of the Debian patches.  It's probably not
#   in our best interest to fix that as a patch series.
# glib, gtk and gdk are all directly relied on in the source, not just

# Libraries used at runtime via dlopen:
# - dev-libs/{serd,sord} - for LV2 support
# - media-libs/{opus,sratom} :: For Opus and LV2 respectively
# - media-sound/lame :: For MP3 export
# - media-video/ffmpeg :: For generic FFMPEG export
#   This one has the interesting property of many versions being
#   supported at runtime.  See: libraries/lib-ffmpeg-support/impl
#   Current support grid:
#   - Lavf - 5[789]
#   - Lavc - 5[789]
#   - Lavu - 5[2567]

RDEPEND="
	dev-db/sqlite:3
	dev-libs/expat
	dev-qt/qt5compat:6
	dev-qt/qtbase:6=[concurrent,dbus,gui,network,widgets,xml]
	dev-qt/qtdeclarative:6
	dev-qt/qtshadertools:6
	dev-qt/qtsvg:6
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/libsndfile
	media-libs/libsoundtouch:=
	media-libs/portaudio[alsa?]
	media-libs/portmidi
	media-libs/portsmf:=
	media-libs/soxr
	media-sound/lame
	sys-apps/util-linux
	sys-libs/zlib:=
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	alsa? ( media-libs/alsa-lib )
	audiocom? (
		net-misc/curl
	)
	ffmpeg? ( media-video/ffmpeg )
	flac? ( media-libs/flac:=[cxx] )
	id3tag? ( media-libs/libid3tag:= )
	lv2? (
		dev-libs/serd
		dev-libs/sord
		media-libs/lilv
		media-libs/lv2
		media-libs/sratom
		media-libs/suil
	)
	mpg123? ( media-sound/mpg123-base )
	ogg? ( media-libs/libogg )
	opus? (
		media-libs/opus
		media-libs/opusfile
	)
	sbsms? ( media-libs/libsbsms )
	twolame? ( media-sound/twolame )
	vamp? ( media-libs/vamp-plugin-sdk )
	vorbis? ( media-libs/libvorbis )
	wavpack? ( media-sound/wavpack )
"
DEPEND="${RDEPEND}
	dev-libs/rapidjson
	x11-base/xorg-proto
	test? ( <dev-cpp/catch-3:0 )"
BDEPEND="
	|| ( dev-lang/nasm dev-lang/yasm )
	dev-qt/qttools:6[linguist]
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/audacity-4.0.0-system-deps.patch
	"${FILESDIR}"/audacity-4.0.0-headers.patch
)

src_prepare() {
	cmake_src_prepare

	append-cppflags "-I${EPREFIX}/usr/include/portsmf -DPROTOTYPES"

	# Remove documentation incorrect installations
	sed -i -e \
		'/install( FILES "${topdir}\/LICENSE.txt" "${topdir}\/README.md"/,+1d' \
		src/CMakeLists.txt || die
}

src_configure() {
	setup-wxwidgets

	local mycmakeargs=(
		# Tell the CMake-based build system it's building a release.
		-DAU4_BUILD_MODE="release"

		-DAU_BUILD_CLOUD_AUDIOCOM=$(usex audiocom on off)

		# Disable telemetry features.
		-DAU_BUILD_USAGEINFO_MODULE=OFF
		-DMUSE_MODULE_DIAGNOSTICS=OFF

		-DMUSE_ENABLE_UNIT_TESTS=$(usex test on off)

		-DAU_MODULE_EFFECTS_LV2=$(usex lv2)
		-DAU_USE_SBSMS=$(usex sbsms)
		-DAU_USE_SOUNDTOUCH=ON
		-DAU_USE_PORTMIXER=$(usex portmixer)
		-DMUSE_MODULE_CLOUD_MUSESCORECOM=OFF
		-DMUSE_COMPILE_USE_CCACHE=OFF
		-DMUSE_COMPILE_USE_UNITY=OFF
		-DMUSE_COMPILE_USE_PCH=OFF
	)

	cmake_src_configure
}

src_test() {
	virtx cmake_src_test
}
