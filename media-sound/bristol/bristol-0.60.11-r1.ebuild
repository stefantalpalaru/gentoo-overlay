# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils autotools

DESCRIPTION="Synthesizer keyboard emulation package: Moog, Hammond and others"
HOMEPAGE="https://sourceforge.net/projects/bristol"
SRC_URI="mirror://sourceforge/bristol/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa oss static-libs"
# osc : configure option but no code it seems...
# jack: fails to build if disabled
# pulseaudio: not fully supported

RDEPEND="
	alsa? ( >=media-libs/alsa-lib-1.0.0 )
	virtual/jack
	x11-libs/libX11"
# osc? ( >=media-libs/liblo-0.22 )
DEPEND="${RDEPEND}
	x11-proto/xproto
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog HOWTO NEWS README )
PATCHES=(
	"${FILESDIR}"/${P}-cflags.patch
	"${FILESDIR}"/${P}-implicit-dec.patch
	"${FILESDIR}"/alsa-atomic-ftbfs.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		--disable-version-check \
		$(use_enable oss) \
		$(use_enable alsa)
}

src_install() {
	default
	prune_libtool_files
}
