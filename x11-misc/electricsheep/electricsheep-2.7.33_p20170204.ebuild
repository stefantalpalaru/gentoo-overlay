# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools git-r3 wxwidgets

DESCRIPTION="realize the collective dream of sleeping computers from all over the internet"
HOMEPAGE="http://electricsheep.org/"
EGIT_REPO_URI="https://github.com/scottdraves/electricsheep"
EGIT_COMMIT="12420cd40dfad8c32fb70b88f3d680d84f795c63"

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
	x11-libs/wxGTK:3.0
	virtual/opengl"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/client_generic"
WX_GTK_VER=3.0

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
