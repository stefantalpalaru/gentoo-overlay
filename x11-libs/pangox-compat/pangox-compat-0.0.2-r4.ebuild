# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GNOME2_LA_PUNT="yes"

inherit gnome2 multilib-minimal

DESCRIPTION="PangoX compatibility library"
HOMEPAGE="http://www.pango.org/"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

RDEPEND=">=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	>=x11-libs/pango-1.36.3[${MULTILIB_USEDEP}]
	>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/pangox-compat-0.0.2-disable-shaper.patch
)

multilib_src_configure() {
	ECONF_SOURCE=${S} gnome2_src_configure --disable-static
}

multilib_src_install() {
	gnome2_src_install
}
