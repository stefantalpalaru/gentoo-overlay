# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
MY_PV=$(ver_rs 2 -0)

inherit autotools flag-o-matic xdg-utils

DESCRIPTION="Gtk (formerly Gnome) Wave Cleaner"
HOMEPAGE="http://gwc.sourceforge.net/
		https://github.com/AlisterH/gwc"
SRC_URI="https://github.com/AlisterH/gwc/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+alsa ogg pulseaudio"
RESTRICT="mirror"

DEPEND="
	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-libs/libpulse )
	media-libs/libsndfile
	ogg? ( media-libs/libvorbis )
	sci-libs/fftw
	x11-libs/gtk+:2
"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	append-cflags -fpermissive -std=gnu17
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
