# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
WX_GTK_VER="3.0"

inherit autotools wxwidgets

DESCRIPTION="realize the collective dream of sleeping computers from all over the internet"
HOMEPAGE="http://electricsheep.org/"
if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/scottdraves/electricsheep"
	S="${WORKDIR}/${P}/client_generic"
else
	MY_COMMIT="4949c31cfdb0d4363cfa726aa3aa8325e540773f"
	SRC_URI="https://github.com/scottdraves/electricsheep/archive/${MY_COMMIT}.zip -> ${P}.zip"
	S="${WORKDIR}/${PN}-${MY_COMMIT}/client_generic"
	KEYWORDS="~amd64 ~x86"
fi

IUSE="video_cards_nvidia"
LICENSE="GPL-2"
SLOT="0"

DEPEND="dev-lang/lua:0
	dev-libs/boost[threads]
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
	"$FILESDIR/electricsheep-glext-prototypes.patch"
	"$FILESDIR/electricsheep-disable-vsync.patch"
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
