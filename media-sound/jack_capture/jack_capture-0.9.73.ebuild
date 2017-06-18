# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs

DESCRIPTION="Recording tool which default operation is to capture what goes out to the soundcard from JACK"
HOMEPAGE="https://github.com/kmatheussen/jack_capture"
SRC_URI="https://github.com/kmatheussen/jack_capture/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="gtk mp3 ogg osc"

RDEPEND="
	gtk? ( x11-libs/gtk+:2 )
	media-libs/libsndfile
	mp3? ( media-sound/lame )
	ogg? ( media-libs/libogg )
	osc? ( media-libs/liblo )
	virtual/jack
"
DEPEND="${RDEPEND}
	gtk? ( virtual/pkgconfig )
"

PATCHES=( "${FILESDIR}/${P}-Makefile.patch" )
DOCS=( README )

src_prepare() {
	default
	use ogg || sed -i -e 's/HAVE_OGG 1/HAVE_OGG 0/' gen_das_config_h.sh
	use mp3 || sed -i -e 's/HAVE_LAME 1/HAVE_LAME 0/' -e '/COMPILEFLAGS -lmp3lame/d' gen_das_config_h.sh
	use osc || sed -i -e 's/HAVE_LIBLO 1/HAVE_LIBLO 0/' -e '/COMPILEFLAGS .* liblo/d' gen_das_config_h.sh
}

src_compile() {
	tc-export CC CXX
	emake PREFIX="${EPREFIX}/usr" jack_capture
	use gtk && emake PREFIX="${EPREFIX}/usr" jack_capture_gui2
}

src_install() {
	dobin jack_capture
	use gtk && dobin jack_capture_gui2
	base_src_install_docs
}
