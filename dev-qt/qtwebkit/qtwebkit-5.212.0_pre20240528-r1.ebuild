# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} python3_13t )
USE_RUBY="ruby27 ruby30 ruby31 ruby32"
MY_COMMIT="756e1c8f23dc2720471298281c421c0076d02df8"

inherit check-reqs cmake flag-o-matic python-any-r1 qmake-utils ruby-single toolchain-funcs

DESCRIPTION="WebKit rendering library for the Qt5 framework (deprecated)"
HOMEPAGE="https://www.qt.io/"
SRC_URI="https://github.com/qtwebkit/qtwebkit/archive/${MY_COMMIT}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/qtwebkit-${MY_COMMIT}"
LICENSE="BSD LGPL-2+"
SLOT="5/5.212"
KEYWORDS="amd64 arm arm64 ppc64 x86"
IUSE="geolocation gles2-only +gstreamer +hyphen +jit multimedia nsplugin opengl orientation +printsupport qml webp X"

REQUIRED_USE="
	nsplugin? ( X )
	qml? ( opengl )
	?? ( gstreamer multimedia )
"

# Dependencies found at Source/cmake/OptionsQt.cmake
QT_MIN_VER="5.12.3:5"
BDEPEND="
	${PYTHON_DEPS}
	${RUBY_DEPS}
	dev-lang/perl
	dev-util/gperf
	>=sys-devel/bison-2.4.3
	sys-devel/flex
	virtual/pkgconfig
"
DEPEND="
	dev-db/sqlite:3
	dev-libs/icu:=
	dev-libs/libxml2
	dev-libs/libxslt
	>=dev-qt/qtcore-${QT_MIN_VER}
	>=dev-qt/qtgui-${QT_MIN_VER}
	>=dev-qt/qtnetwork-${QT_MIN_VER}
	>=dev-qt/qtwidgets-${QT_MIN_VER}=
	media-libs/libpng:0=
	media-libs/woff2
	media-libs/libjpeg-turbo:0
	geolocation? ( >=dev-qt/qtpositioning-${QT_MIN_VER} )
	gstreamer? (
		dev-libs/glib:2
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-bad:1.0
		media-libs/gst-plugins-base:1.0
	)
	hyphen? ( dev-libs/hyphen )
	multimedia? ( >=dev-qt/qtmultimedia-${QT_MIN_VER}[widgets] )
	opengl? (
		>=dev-qt/qtgui-${QT_MIN_VER}[gles2-only=]
		>=dev-qt/qtopengl-${QT_MIN_VER}[gles2-only=]
	)
	orientation? ( >=dev-qt/qtsensors-${QT_MIN_VER} )
	printsupport? ( >=dev-qt/qtprintsupport-${QT_MIN_VER} )
	qml? (
		>=dev-qt/qtdeclarative-${QT_MIN_VER}
		>=dev-qt/qtwebchannel-${QT_MIN_VER}[qml]
	)
	webp? ( media-libs/libwebp:= )
	X? (
		x11-libs/libX11
		x11-libs/libXcomposite
		x11-libs/libXrender
	)
"
RDEPEND="${DEPEND}"

CHECKREQS_DISK_BUILD="16G" # bug 417307

PATCHES=(
	"${FILESDIR}"/qtwebkit-5.212.0_pre20240528-gcc14.patch
	"${FILESDIR}"/qtwebkit-5.212.0_pre20240528-icu76.patch
	"${FILESDIR}"/qtwebkit-5.212.0_pre20240528-ruby.patch
)

_check_reqs() {
	if [[ ${MERGE_TYPE} != binary ]] && is-flagq "-g*" && ! is-flagq "-g*0"; then
		einfo "Checking for sufficient disk space to build ${PN} with debugging flags"
		check-reqs_$1
	fi
}

pkg_pretend() {
	_check_reqs pkg_pretend
}

pkg_setup() {
	_check_reqs pkg_setup
	python-any-r1_pkg_setup
}

src_configure() {
	# Respect CC, otherwise fails on prefix, bug #395875
	tc-export CC

	# Multiple rendering bugs on youtube, github, etc without this, bug #547224
	append-flags $(test-flags -fno-strict-aliasing)

	append-cxxflags -fpermissive

	local mycmakeargs=(
		-DPORT=Qt
		-DENABLE_API_TESTS=OFF
		-DENABLE_TOOLS=OFF
		-DENABLE_GEOLOCATION=$(usex geolocation)
		-DUSE_GSTREAMER=$(usex gstreamer)
		-DUSE_LIBHYPHEN=$(usex hyphen)
		-DENABLE_JIT=$(usex jit)
		-DUSE_QT_MULTIMEDIA=$(usex multimedia)
		-DENABLE_NETSCAPE_PLUGIN_API=$(usex nsplugin)
		-DENABLE_OPENGL=$(usex opengl)
		-DENABLE_PRINT_SUPPORT=$(usex printsupport)
		-DENABLE_DEVICE_ORIENTATION=$(usex orientation)
		-DENABLE_WEBKIT2=$(usex qml)
		$(cmake_use_find_package webp WebP)
		-DENABLE_X11_TARGET=$(usex X)
	)

	if has_version "virtual/rubygems[ruby_targets_ruby32]"; then
		mycmakeargs+=( -DRUBY_EXECUTABLE=$(type -P ruby32) )
	elif has_version "virtual/rubygems[ruby_targets_ruby31]"; then
		mycmakeargs+=( -DRUBY_EXECUTABLE=$(type -P ruby31) )
	elif has_version "virtual/rubygems[ruby_targets_ruby30]"; then
		mycmakeargs+=( -DRUBY_EXECUTABLE=$(type -P ruby30) )
	elif has_version "virtual/rubygems[ruby_targets_ruby27]"; then
		mycmakeargs+=( -DRUBY_EXECUTABLE=$(type -P ruby27) )
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install

	# bug 572056
	if [[ ! -f ${ED}$(qt5_get_libdir)/libQt5WebKit.so ]]; then
		eerror "${CATEGORY}/${PF} could not build due to a broken ruby environment."
		die 'Check "eselect ruby" and ensure you have a working ruby in your $PATH'
	fi
}
