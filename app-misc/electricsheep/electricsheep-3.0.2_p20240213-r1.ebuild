# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
WX_GTK_VER="3.0-gtk3"
MY_COMMIT="5fbbb684752be06ccbea41639968aa7f1cc678dd"

inherit autotools flag-o-matic wxwidgets

DESCRIPTION="realize the collective dream of sleeping computers from all over the internet"
HOMEPAGE="http://electricsheep.org/
		https://github.com/scottdraves/electricsheep"
SRC_URI="https://github.com/scottdraves/electricsheep/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}/client_generic"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="video_cards_nvidia"

DEPEND="dev-lang/lua:5.1
	dev-libs/boost:0=
	dev-libs/expat
	dev-libs/tinyxml
	gnome-base/libgtop
	media-gfx/flam3
	media-libs/freeglut
	media-libs/glee
	media-libs/libpng:*
	media-video/ffmpeg:0
	net-misc/curl
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXrender
	x11-libs/wxGTK:${WX_GTK_VER}
	virtual/opengl"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/electricsheep-disable-vsync.patch
	"${FILESDIR}"/electricsheep-boost-1.85.patch
)

src_prepare() {
	default

	setup-wxwidgets
	eautoreconf
	rm -f DisplayOutput/OpenGL/{GLee.c,GLee.h}
}

src_configure() {
	# "eselect opengl" doesn't seem to affect link-time paths, so we need to unfuck that here
	use video_cards_nvidia && append-ldflags -L/usr/$(get_libdir)/opengl/nvidia/lib

	append-ldflags -lpthread

	econf
	# get rid of the RUNPATH that interferes with hardware accelerated OpenGL drivers
	sed -i -e '/^hardcode_libdir_flag_spec/d' libtool
}
