# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
inherit eutils toolchain-funcs multilib

DESCRIPTION="MIDI controlled DSP tonewheel organ"
HOMEPAGE="http://setbfree.org"
SRC_URI="https://github.com/pantherb/setBfree/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="convolution"

RDEPEND="dev-lang/tcl:0
	dev-lang/tk:0
	media-fonts/dejavu
	media-sound/jack-audio-connection-kit
	>=media-libs/alsa-lib-1.0.0
	media-libs/ftgl
	media-libs/liblo
	media-libs/lv2
	media-libs/mesa
	convolution? (
		media-libs/libsndfile
		>=media-libs/zita-convolver-3.1.0
	)"
DEPEND="${RDEPEND}
	sys-apps/help2man
	virtual/pkgconfig"

DOCS=(ChangeLog README.md)
PATCHES=(
	"${FILESDIR}/${PN}-multilib-strict-and-cflags-99999999.patch"
)

S="${WORKDIR}/setBfree-${PV}"

src_compile() {
	tc-export CC CXX
	emake PREFIX="${EPREFIX}"/usr \
		FONTFILE="/usr/share/fonts/dejavu/DejaVuSans-Bold.ttf" \
		$(use convolution && echo "ENABLE_CONVOLUTION=yes") || die "died running emake, $FUNCNAME"
}

src_install() {
	emake DESTDIR="${D}" \
		$(use convolution && echo "ENABLE_CONVOLUTION=yes") \
		FONTFILE="/usr/share/fonts/dejavu/DejaVuSans-Bold.ttf" \
		PREFIX="${EPREFIX}"/usr \
		LIBDIR="$(get_libdir)" \
		install

	doman doc/*.1

	insinto /usr/share/pixmaps
	doins doc/setBfree.png

	make_desktop_entry setBfree-start setBfree setBfree "AudioVideo;Audio;"
}

pkg_postinst() {
	elog "Use setBfree-start to run setBfree."
	elog "For the LV2 GUI you need a LV2 host with Gtk2 support, like media-sound/jalv with the 'gtk2' USE flag enabled."
	elog "Start the LV2 plugin like this: jalv.gtk -l ~/.config/setBfree http://gareus.org/oss/lv2/b_synth"
}
