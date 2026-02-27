# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
CMAKE_MAKEFILE_GENERATOR="emake"
CMAKE_BUILD_TYPE=Release
GMIC_COMMIT="577546ca7a40da09271b55e608c0cdeeee2ae8f4"
GMIC_QT_COMMIT="d4ecc26b0843e7c6815f399f7282592c21568de2"
GMIC_QT_URI="https://github.com/GreycLab/gmic-qt/archive/${GMIC_QT_COMMIT}.tar.gz -> gmic-qt-${GMIC_QT_COMMIT}.gh.tar.gz"

inherit bash-completion-r1 cmake flag-o-matic qmake-utils toolchain-funcs

DESCRIPTION="GREYC's Magic Image Converter"
HOMEPAGE="http://gmic.eu/
	https://github.com/GreycLab/gmic
	https://framagit.org/dtschump/gmic
	https://github.com/GreycLab/gmic-qt"
SRC_URI="https://github.com/GreycLab/gmic/archive/${GMIC_COMMIT}.tar.gz -> ${PN}-${GMIC_COMMIT}.gh.tar.gz
	https://gmic.eu/gmic_stdlib_community$(ver_rs 1- '').h
	gimp? ( ${GMIC_QT_URI} )
	gui? ( ${GMIC_QT_URI} )
"
S="${WORKDIR}/${PN}-${GMIC_COMMIT}"
LICENSE="CeCILL-2 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="bash-completion +cli ffmpeg +fftw gimp graphicsmagick gui jpeg opencv openexr +openmp png static-libs tiff X"
REQUIRED_USE="
	|| ( cli gimp gui )
	gimp? ( png fftw X )
	gui? ( png fftw X )
"
RESTRICT="mirror network-sandbox"

QT_DEPS="
	dev-qt/qtbase:6[gui,network,widgets]
"
COMMON_DEPEND="
	fftw? ( sci-libs/fftw:3.0=[threads] )
	gimp? (
		media-gfx/gimp:0/3
		${QT_DEPS}
	)
	graphicsmagick? ( media-gfx/graphicsmagick:0= )
	gui? ( ${QT_DEPS} )
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

GMIC_QT_DIR="gmic-qt-${GMIC_QT_COMMIT}"

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

	if use gimp || use gui ; then
		sed -i \
			-e '/CMAKE_CXX_FLAGS_RELEASE/d' \
			../${GMIC_QT_DIR}/CMakeLists.txt || die "sed failed"
		local S="${WORKDIR}/${GMIC_QT_DIR}"
		cd ../${GMIC_QT_DIR}
		patch -p1 -i "${FILESDIR}/gmic-3.1.6-stripping.patch" || die
		patch -p1 -i "${FILESDIR}/gmic-3.2.0-system-gmic.patch" || die
		cd -
		cmake_src_prepare
	fi
}

src_configure() {
	# for "lrelease"
	local PATH="${PATH}:$(qt5_get_bindir)"

	local mycmakeargs=(
		-DBUILD_LIB=ON
		-DBUILD_LIB_STATIC=$(usex static-libs ON OFF)
		-DBUILD_CLI=$(usex cli ON OFF)
		-DBUILD_MAN=$(usex cli ON OFF)
		-DBUILD_BASH_COMPLETION=$(usex cli $(usex bash-completion ON OFF) OFF)
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
	append-ldflags -L"${WORKDIR}/gmic-${GMIC_COMMIT}_build"
	mycmakeargs=(
		-DENABLE_DYNAMIC_LINKING=ON
		-DENABLE_SYSTEM_GMIC=ON
		-DGMIC_PATH="${WORKDIR}/gmic/src"
		-DGMIC_LIB_PATH="${WORKDIR}/gmic-${GMIC_COMMIT}_build"
		-DBUILD_WITH_QT6=ON
	)
	local BUILD_DIR
	if use gimp; then
		BUILD_DIR=${WORKDIR}/gimp_build
		mycmakeargs+=( -DGMIC_QT_HOST=gimp3 )
		cmake_src_configure
	fi
	if use gui; then
		BUILD_DIR=${WORKDIR}/gui_build
		mycmakeargs+=( -DGMIC_QT_HOST=none )
		cmake_src_configure
	fi
}

src_compile() {
	cmake_src_compile

	# gmic-qt
	local S="${WORKDIR}/${GMIC_QT_DIR}"
	local BUILD_DIR
	if use gimp; then
		BUILD_DIR="${WORKDIR}/gimp_build"
		cmake_src_compile
	fi
	if use gui; then
		BUILD_DIR="${WORKDIR}/gui_build"
		cmake_src_compile
	fi
}

src_install() {
	dodoc README

	# - the Gimp plugin dir is also searched by non-Gimp tools, and it's
	#   hardcoded in "gmic_stdlib.gmic"
	# - using the GMIC_SYSTEM_PATH env var to specify another system dir here
	#   might mean that this big file will be automatically downloaded in
	#   "~/.config/gmic/" when the user runs a tool before updating and sourcing
	#   the new environment
	local PLUGIN_DIR="/usr/$(get_libdir)/gimp/3.0/plug-ins/gmic_gimp_qt"
	insinto "${PLUGIN_DIR}"
	doins resources/*.gmz

	cmake_src_install

	# By default, "gmic.cpp" includes "gmic.h" which defines "cimg_plugin" to "gmic.cpp" and then
	# includes "CImg.h" which includes "cimg_plugin" which is "gmic.cpp", of course.
	#
	# Yes, upstream is bad and they should feel bad. Undo this madness so we can build media-gfx/zart
	# using the installed "gmic.h".
	sed -i -e '/^#define cimg.*_plugin/d' "${ED}/usr/include/gmic.h" || die "sed failed"

	use cli && use bash-completion && newbashcomp "${BUILD_DIR}/resources/${PN}_bashcompletion.sh" ${PN}

	# gmic-qt
	if use gimp; then
		exeinto "${PLUGIN_DIR}"
		doexe "${WORKDIR}/gimp_build/gmic_gimp_qt"
	fi
	if use gui; then
		dobin "${WORKDIR}/gui_build/gmic_qt"
	fi
}
