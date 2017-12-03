# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools git-r3

DESCRIPTION="Create, manipulate, and optimize GIF images and animations"
HOMEPAGE="https://www.lcdf.org/~eddietwo/gifsicle/ https://github.com/kohler/gifsicle"
EGIT_REPO_URI="https://github.com/kohler/gifsicle.git"

LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS=""
IUSE="X"

RDEPEND="X? ( x11-libs/libX11 x11-libs/libXt )"
DEPEND="${RDEPEND}
	X? ( x11-proto/xproto )"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(usex X "" "--disable-gifview")
}
