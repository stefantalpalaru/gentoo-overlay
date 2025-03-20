# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
CMAKE_MAKEFILE_GENERATOR="emake"
CMAKE_BUILD_TYPE=Release

inherit bash-completion-r1 cmake flag-o-matic qmake-utils toolchain-funcs

DESCRIPTION="GREYC's Magic Image Converter"
HOMEPAGE="http://gmic.eu/
	https://github.com/GreycLab/gmic
	https://framagit.org/dtschump/gmic"
GMIC_QT_URI="https://github.com/GreycLab/gmic-qt/archive/v.${PV}.tar.gz -> gmic-qt-${PV}.tar.gz"
SRC_URI="https://github.com/GreycLab/gmic/archive/v.${PV}.tar.gz -> ${P}.tar.gz
	https://gmic.eu/gmic_stdlib_community$(ver_rs 1- '').h
"
S="${WORKDIR}/${PN}-v.${PV}"
LICENSE="CeCILL-2 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="bash-completion ffmpeg +fftw graphicsmagick jpeg opencv openexr +openmp png static-libs tiff X"
RESTRICT="network-sandbox mirror"

COMMON_DEPEND="
	fftw? ( sci-libs/fftw:3.0=[threads] )
	graphicsmagick? ( media-gfx/graphicsmagick:0= )
	jpeg? ( media-libs/libjpeg-turbo:0 )
	~media-libs/cimg-${PV}
	net-misc/curl
	opencv? ( >=media-libs/opencv-2.3.1a-r1:0= )
	openexr? (
		dev-libs/imath:=
		media-libs/openexr:0=
	)
	png? ( media-libs/libpng:0= )
	sys-libs/zlib:0=
	tiff? ( media-libs/tiff:0 )
	X? (
		x11-libs/libX11
		x11-libs/libXext
	)
"
RDEPEND="${COMMON_DEPEND}
	ffmpeg? ( media-video/ffmpeg:0= )
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
"

GMIC_QT_DIR="gmic-qt-v.${PV}"

pkg_pretend() {
	if use openmp; then
		tc-check-openmp
	fi
}

src_prepare() {
	cp -a "${DISTDIR}/gmic_stdlib_community$(ver_rs 1- '').h" src/gmic_stdlib_community.h || die
	cmake_src_prepare
	PATCHES=()

	ln -sr ../${PN}-v.${PV} ../${PN}
}

src_configure() {
	# for "lrelease"
	local PATH="${PATH}:$(qt5_get_bindir)"

	local mycmakeargs=(
		-DBUILD_LIB=ON
		-DBUILD_LIB_STATIC=$(usex static-libs ON OFF)
		-DBUILD_CLI=ON
		-DBUILD_MAN=ON
		-DBUILD_BASH_COMPLETION=$(usex bash-completion ON OFF)
		-DENABLE_X=$(usex X ON OFF)
		-DENABLE_FFMPEG=$(usex ffmpeg ON OFF)
		-DENABLE_FFTW=$(usex fftw ON OFF)
		-DENABLE_GRAPHICSMAGICK=$(usex graphicsmagick ON OFF)
		-DENABLE_JPEG=$(usex jpeg ON OFF)
		-DENABLE_OPENCV=$(usex opencv ON OFF)
		-DENABLE_OPENEXR=$(usex openexr ON OFF)
		-DENABLE_OPENMP=$(usex openmp ON OFF)
		-DENABLE_PNG=$(usex png ON OFF)
		-DENABLE_TIFF=$(usex tiff ON OFF)
		-DENABLE_ZLIB=ON
		-DENABLE_DYNAMIC_LINKING=ON
		-DCUSTOM_CFLAGS=ON
		-DUSE_SYSTEM_CIMG=ON
	)

	cmake_src_configure

	# gmic-qt
	local CMAKE_USE_DIR="${WORKDIR}/${GMIC_QT_DIR}"
	append-cppflags -I"${WORKDIR}/gmic/src"
	append-ldflags -L"${WORKDIR}/gmic-v.${PV}_build"
	mycmakeargs=(
		-DENABLE_DYNAMIC_LINKING=ON
		-DENABLE_SYSTEM_GMIC=ON
		-DGMIC_LIB_PATH="${WORKDIR}/gmic-v.${PV}_build"
	)
}

src_compile() {
	cmake_src_compile

	# gmic-qt
	local S="${WORKDIR}/${GMIC_QT_DIR}"
	local BUILD_DIR
}

src_install() {
	dodoc README

	# - the Gimp plugin dir is also searched by non-Gimp tools, and it's
	#   hardcoded in "gmic_stdlib.gmic"
	# - using the GMIC_SYSTEM_PATH env var to specify another system dir here
	#   might mean that this big file will be automatically downloaded in
	#   "~/.config/gmic/" when the user runs a tool before updating and sourcing
	#   the new environment
	local PLUGIN_DIR="/usr/$(get_libdir)/gimp/2.0/plug-ins/"
	insinto "${PLUGIN_DIR}"
	doins resources/*.gmz

	cmake_src_install

	# By default, "gmic.cpp" includes "gmic.h" which defines "cimg_plugin" to "gmic.cpp" and then
	# includes "CImg.h" which includes "cimg_plugin" which is "gmic.cpp", of course.
	#
	# Yes, upstream is bad and they should feel bad. Undo this madness so we can build media-gfx/zart
	# using the installed "gmic.h".
	sed -i -e '/^#define cimg.*_plugin/d' "${ED}/usr/include/gmic.h" || die "sed failed"

	use bash-completion && newbashcomp "${WORKDIR}/${PN}-v.${PV}_build/resources/${PN}_bashcompletion.sh" ${PN}
}
