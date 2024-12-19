# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
AUTOTOOLS_AUTORECONF=yes

inherit autotools git-r3 vala

DESCRIPTION="systray widget used to load ICC color profiles with different color temperatures"
HOMEPAGE="https://github.com/stefantalpalaru/iccloader"
EGIT_REPO_URI="https://github.com/stefantalpalaru/iccloader.git"
LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS=""
IUSE="nls"

RDEPEND="
	dev-libs/glib:2
	media-gfx/argyllcms
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	$(vala_depend)
	>=dev-util/intltool-0.50
	virtual/pkgconfig"

src_prepare() {
	default
	vala_setup
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable nls)
	)
	econf
}
