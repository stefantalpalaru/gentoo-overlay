# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs git-r3

DESCRIPTION="MIDI controlled DSP tonewheel organ"
HOMEPAGE="http://setbfree.org"
EGIT_REPO_URI="https://github.com/pantherb/setBfree.git"
LICENSE="GPL-2"
SLOT="0"

RDEPEND="dev-lang/tcl:0
	dev-lang/tk:0
	media-fonts/dejavu
	virtual/jack
	>=media-libs/alsa-lib-1.0.0
	media-libs/ftgl
	media-libs/liblo
	media-libs/lv2
	media-libs/mesa:0
"
DEPEND="${RDEPEND}
	sys-apps/help2man
	virtual/pkgconfig"

DOCS=(ChangeLog README.md)
PATCHES=(
	"${FILESDIR}/setbfree-multilib-strict-and-cflags-99999999-r1.patch"
)

src_compile() {
	tc-export CC CXX
	emake PREFIX="${EPREFIX}"/usr \
		FONTFILE="/usr/share/fonts/dejavu/DejaVuSans-Bold.ttf" \
		|| die "died running emake, $FUNCNAME"
}

src_install() {
	emake DESTDIR="${D}" \
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
