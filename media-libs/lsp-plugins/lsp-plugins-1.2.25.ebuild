# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs xdg

DESCRIPTION="Linux Studio Plugins"
HOMEPAGE="https://lsp-plug.in"
SRC_URI="https://github.com/lsp-plugins/lsp-plugins/releases/download/${PV}/${PN}-src-${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}"
LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 x86"
IUSE="clap doc gstreamer jack ladspa +lv2 test vst vst3 X"
REQUIRED_USE="|| ( clap gstreamer jack ladspa lv2 vst vst3 )
	test? ( jack )"

RESTRICT="!test? ( test )"

BDEPEND="doc? ( dev-lang/php:* )"
DEPEND="
	media-libs/libglvnd[X]
	media-libs/libsndfile
	clap? (
		media-libs/freetype
		x11-libs/cairo[X]
		x11-libs/libX11
		x11-libs/libXrandr
	)
	gstreamer? (
		media-libs/freetype
		media-libs/gstreamer:1.0
		x11-libs/cairo[X]
		x11-libs/libX11
		x11-libs/libXrandr
	)
	jack? (
		media-libs/freetype
		virtual/jack
		x11-libs/cairo[X]
		x11-libs/libX11
		x11-libs/libXrandr
	)
	ladspa? ( media-libs/ladspa-sdk )
	lv2? (
		media-libs/freetype
		media-libs/lv2
		x11-libs/cairo[X]
		x11-libs/libX11
		x11-libs/libXrandr
	)
	vst? (
		media-libs/freetype
		x11-libs/cairo[X]
		x11-libs/libX11
		x11-libs/libXrandr
	)
	vst3? (
		media-libs/freetype
		x11-libs/cairo[X]
		x11-libs/libX11
		x11-libs/libXrandr
	)
"
RDEPEND="${DEPEND}"

src_configure() {
	# -Werror=odr
	# https://bugs.gentoo.org/875833
	#
	# Actually the whole thing is kind of a waste of time. It looks like
	# programs use LDFLAGS, but libraries do not! So some things don't
	# build with LTO, while other things don't build when LTO is enabled.
	# Attempting to build with LTO is just a waste of time and cycles.
	#
	# This was reported upstream but the ticket closed. Abandon hope.
	filter-lto

	MODULES="ui"
	use clap && MODULES+=" clap"
	use doc && MODULES+=" doc"
	use gstreamer && MODULES+=" gst"
	use jack && MODULES+=" jack"
	use ladspa && MODULES+=" ladspa"
	use lv2 && MODULES+=" lv2"
	use vst && MODULES+=" vst2"
	use vst3 && MODULES+=" vst3"
	use X && MODULES+=" xdg"
	emake \
		FEATURES="${MODULES}" \
		PREFIX="/usr" \
		LIBDIR="/usr/$(get_libdir)" \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		LD="$(tc-getLD)" \
		CFLAGS_EXT="${CFLAGS}" \
		CXXFLAGS_EXT="${CXXFLAGS}" \
		LDFLAGS_EXT="$(raw-ldflags)" \
		VERBOSE=1 \
		config
}

src_compile() {
	emake \
		FEATURES="${MODULES}" \
		PREFIX="/usr" \
		LIBDIR="/usr/$(get_libdir)" \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		LD="$(tc-getLD)" \
		CFLAGS_EXT="${CFLAGS}" \
		CXXFLAGS_EXT="${CXXFLAGS}" \
		LDFLAGS_EXT="$(raw-ldflags)" \
		VERBOSE=1
}

src_install() {
	emake \
		FEATURES="${MODULES}" \
		PREFIX="/usr" \
		DESTDIR="${ED}" \
		LIB_PATH="/usr/$(get_libdir)" \
		VERBOSE=1 \
		install
}
