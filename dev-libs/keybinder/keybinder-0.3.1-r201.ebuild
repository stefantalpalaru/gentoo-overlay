# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
LUA_COMPAT=( lua5-1 )
inherit autotools lua-single python-r1

DESCRIPTION="A library for registering global keyboard shortcuts"
HOMEPAGE="https://github.com/engla/keybinder"
SRC_URI="https://github.com/engla/keybinder/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 x86"
IUSE="+introspection lua python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND=">=x11-libs/gtk+-2.20:2
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender
	introspection? ( dev-libs/gobject-introspection )
	lua? ( ${LUA_DEPS} )
	python? ( ${PYTHON_DEPS}
		>=dev-python/pygobject-2.15.3:2[${PYTHON_USEDEP}]
		>=dev-python/pygtk-2.12[${PYTHON_USEDEP}]
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	local myconf=(
		$(use_enable introspection)
		$(use_enable python)
	)
	# upstream failed at AC_ARG_ENABLE
	use lua || myconf+=( --disable-lua )

	if use python; then
		python_foreach_impl econf "${myconf[@]}"
	else
		econf "${myconf[@]}"
	fi
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
