# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools xdg-utils

MY_PV=$(ver_rs 2 -0)

DESCRIPTION="Gtk (formerly Gnome) Wave Cleaner"
HOMEPAGE="http://gwc.sourceforge.net/
		https://github.com/AlisterH/gwc"
SRC_URI="https://github.com/AlisterH/gwc/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+alsa ogg pulseaudio"

DEPEND="
	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-libs/libpulse )
	media-libs/libsndfile
	ogg? ( media-libs/libvorbis )
	sci-libs/fftw
	x11-libs/gtk+:2
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	default

	export OPT_CFLAGS="${CFLAGS}"
	sed -i \
		-e '/gtk-update-icon-cache/d' \
		Makefile.am || die

	eautoreconf
}

src_configure() {
	local myconf=(
		$(use_enable alsa)
		$(use_enable ogg)
	)

	if use pulseaudio; then
		# broken configure.ac
		myconf+=(
			--enable-pa
		)
	fi

	econf "${myconf[@]}"

	cd meschach
	econf --with-sparse
	cd - 2>/dev/null
}

src_compile() {
	cd meschach || die
	emake part1 part2 part3
	cp machine.h .. || die
	cd - 2>/dev/null

	emake
}

src_install() {
	default

	rm -rf "${ED}/usr/share/doc/gtk-wave-cleaner"
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
