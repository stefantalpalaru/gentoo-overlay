# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit base toolchain-funcs multilib git-2

DESCRIPTION="MIDI controlled DSP tonewheel organ"
HOMEPAGE="http://setbfree.org"
EGIT_REPO_URI="https://github.com/pantherb/setBfree.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="convolution"

RDEPEND="dev-lang/tcl
	dev-lang/tk
	media-fonts/ttf-bitstream-vera
	media-sound/jack-audio-connection-kit
	>=media-libs/alsa-lib-1.0.0
	media-libs/ftgl
	media-libs/liblo
	media-libs/lv2
	media-libs/mesa
	convolution? ( media-libs/libsndfile
		>=media-libs/zita-convolver-3.1.0 )"
DEPEND="${RDEPEND}
	sys-apps/help2man
	virtual/pkgconfig"

DOCS=(ChangeLog README.md)
PATCHES=(
	"${FILESDIR}/${PN}-multilib-strict-and-cflags-${PV}.patch"
)

src_prepare() {
	base_src_prepare
	sed -i -e "s/private/privatex/g" vb3kb/vb3kb.c vb3kb/vb3kb.h vb3kb/midi_jack.c vb3kb/midi_alsa.c || die "sed failed!"
}

src_compile() {
	tc-export CC CXX
	base_src_make PREFIX="${EPREFIX}"/usr \
		FONTFILE="/usr/share/fonts/ttf-bitstream-vera/VeraBd.ttf" \
		$(use convolution && echo "ENABLE_CONVOLUTION=yes")
}

src_install() {
	base_src_install $(use convolution && echo "ENABLE_CONVOLUTION=yes") \
		FONTFILE="/usr/share/fonts/ttf-bitstream-vera/VeraBd.ttf" \
		PREFIX="${EPREFIX}"/usr LIBDIR="$(get_libdir)"

	doman doc/*.1

	insinto /usr/share/pixmaps
	doins doc/setBfree.png

	make_desktop_entry setBfree-start setBfree setBfree "AudioVideo;Audio;"
}

pkg_postinst() {
	elog "Use setBfree-start to run setBfree."
	elog "For the LV2 GUI you need a LV2 host with Gtk2 support, like media-sound/jalv with the 'gtk2' USE flag enabled."
	elog "Start the LV2 plugin like this: jalv.gtk http://gareus.org/oss/lv2/b_synth"
}
