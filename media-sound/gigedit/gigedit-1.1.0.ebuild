# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils flag-o-matic

DESCRIPTION="An instrument editor for gig files"
HOMEPAGE="http://www.linuxsampler.org/"
SRC_URI="http://download.linuxsampler.org/packages/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-cpp/gtkmm:3.0
	>=dev-libs/libsigc++-2.0
	>=media-libs/libgig-4.1.0
	>=media-libs/libsndfile-1.0.11
	>=media-sound/linuxsampler-2.1.0"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35.0
	virtual/pkgconfig"

src_configure() {
	append-cxxflags -std=c++11
	econf --disable-static
}

src_install() {
	default
	prune_libtool_files --modules
}
