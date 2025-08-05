# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake gnome2-utils multilib-minimal

DESCRIPTION="ISO/IEC 23008-12:2017 HEIF and AVIF file format decoder and encoder"
HOMEPAGE="https://github.com/strukturag/libheif"
SRC_URI="https://github.com/strukturag/libheif/releases/download/v${PV}/${P}.tar.gz"
LICENSE="GPL-3 MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="aom +dav1d ffmpeg gdk-pixbuf openh264 rav1e +svt-av1 +tools +tools-heif-view test +x265"
RESTRICT="!test? ( test )"

DEPEND="
	dav1d? ( media-libs/dav1d:=[${MULTILIB_USEDEP}] )
	media-libs/libpng:0=[${MULTILIB_USEDEP}]
	media-libs/libwebp:0=[${MULTILIB_USEDEP}]
	media-libs/tiff:=[${MULTILIB_USEDEP}]
	ffmpeg? ( media-video/ffmpeg:0=[${MULTILIB_USEDEP}] )
	sys-libs/zlib:=[${MULTILIB_USEDEP}]
	media-libs/libjpeg-turbo:0=[${MULTILIB_USEDEP}]
	aom? ( >=media-libs/libaom-2.0.0:=[${MULTILIB_USEDEP}] )
	gdk-pixbuf? ( x11-libs/gdk-pixbuf[${MULTILIB_USEDEP}] )
	rav1e? ( media-video/rav1e:= )
	svt-av1? ( <media-libs/svt-av1-4.0.0[${MULTILIB_USEDEP}] )
	tools-heif-view? ( media-libs/libsdl2 )
	x265? (
		media-libs/libde265:=[${MULTILIB_USEDEP}]
		media-libs/x265:=[${MULTILIB_USEDEP}]
	)
"
RDEPEND="${DEPEND}"

src_prepare() {
	cmake_src_prepare

	multilib_copy_sources
}

multilib_src_configure() {
	local mycmakeargs=(
		# We don't want to use MULTILIB_WRAPPED_HEADERS with "heif_version.h"
		# because it breaks Digikam, but the "LIBHEIF_PLUGIN_DIRECTORY" it
		# defines is architecture-specific, so we disable plugins entirely.
		-DENABLE_PLUGIN_LOADING=OFF
		-DWITH_AOM_DECODER=$(usex aom)
		-DWITH_AOM_ENCODER=$(usex aom)
		-DWITH_DAV1D=$(usex dav1d)
		-DWITH_EXAMPLES=$(usex tools)
		-DWITH_EXAMPLE_HEIF_VIEW=$(usex tools-heif-view)
		-DWITH_FFMPEG_DECODER=$(usex ffmpeg)
		-DWITH_GDK_PIXBUF=$(usex gdk-pixbuf)
		-DWITH_JPEG_DECODER=ON
		-DWITH_JPEG_ENCODER=ON
		-DWITH_KVAZAAR=OFF
		-DWITH_LIBDE265=$(usex x265)
		-DWITH_LIBSHARPYUV=ON
		-DWITH_OpenH264_DECODER=$(usex openh264)
		-DWITH_OPENJPH_DECODER=OFF
		-DWITH_OPENJPH_ENCODER=OFF
		-DWITH_OpenJPEG_DECODER=ON
		-DWITH_OpenJPEG_ENCODER=ON
		-DWITH_RAV1E="$(multilib_native_usex rav1e)"
		-DWITH_SvtEnc="$(usex svt-av1)"
		-DWITH_UVG266=OFF
		-DWITH_VVDEC=OFF
		-DWITH_VVENC=OFF
		-DWITH_X265=$(usex x265)
	)
	cmake_src_configure
}

multilib_src_compile() {
	cmake_src_compile
}

multilib_src_test() {
	cmake_src_test
}

multilib_src_install() {
	cmake_src_install
}

multilib_src_install_all() {
	einstalldocs
}

pkg_postinst() {
	use gdk-pixbuf && multilib_foreach_abi gnome2_gdk_pixbuf_update
}

pkg_postrm() {
	use gdk-pixbuf && multilib_foreach_abi gnome2_gdk_pixbuf_update
}
