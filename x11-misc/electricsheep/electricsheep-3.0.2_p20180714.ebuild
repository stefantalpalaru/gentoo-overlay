# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
WX_GTK_VER="3.0"

inherit autotools wxwidgets

DESCRIPTION="realize the collective dream of sleeping computers from all over the internet"
HOMEPAGE="http://electricsheep.org/"
MY_COMMIT="4949c31cfdb0d4363cfa726aa3aa8325e540773f"
SRC_URI="https://github.com/scottdraves/electricsheep/archive/${MY_COMMIT}.zip -> ${P}.zip"

IUSE=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-lang/lua:0
	dev-libs/boost[threads]
	dev-libs/expat
	dev-libs/tinyxml
	gnome-base/libgtop
	media-gfx/flam3
	media-libs/freeglut
	media-libs/glee
	media-libs/libpng:*
	media-video/ffmpeg:0/55.57.57
	net-misc/curl
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXrender
	x11-libs/wxGTK:${WX_GTK_VER}
	virtual/opengl"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${MY_COMMIT}/client_generic"

src_prepare() {
	default

	setup-wxwidgets
	eautoreconf
}

src_configure() {
	econf
	# get rid of the RUNPATH that interferes with hardware accelerated OpenGL drivers
	sed -i -e '/^hardcode_libdir_flag_spec/d' libtool
}
