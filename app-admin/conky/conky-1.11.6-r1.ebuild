# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake linux-info readme.gentoo-r1 xdg

DESCRIPTION="An advanced, highly configurable system monitor for X"
HOMEPAGE="https://github.com/brndnmtthws/conky"
SRC_URI="https://github.com/brndnmtthws/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3 BSD LGPL-2.1 MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86"
IUSE="apcupsd cmus curl hddtemp ical iconv imlib iostats ipv6 irc
	lua-cairo lua-imlib lua-rsvg luajit math moc mpd mysql nano-syntax ncurses
	nvidia portmon pulseaudio rss systemd thinkpad truetype vim-syntax
	weather-metar webserver wifi X xmms2"

COMMON_DEPEND="
	X? (
		imlib? ( media-libs/imlib2[X] )
		lua-cairo? ( >=dev-lua/toluapp-1.0.93 x11-libs/cairo[X] )
		lua-imlib? ( >=dev-lua/toluapp-1.0.93 media-libs/imlib2[X] )
		lua-rsvg? ( >=dev-lua/toluapp-1.0.93 gnome-base/librsvg )
		nvidia? ( x11-drivers/nvidia-drivers[tools,static-libs] )
		truetype? ( x11-libs/libXft >=media-libs/freetype-2 )
		x11-libs/libX11
		x11-libs/libXdamage
		x11-libs/libXinerama
		x11-libs/libXfixes
		x11-libs/libXext
		xmms2? ( media-sound/xmms2 )
	)
	cmus? ( media-sound/cmus )
	curl? ( net-misc/curl )
	ical? ( dev-libs/libical:= )
	iconv? ( virtual/libiconv )
	irc? ( net-libs/libircclient )
	luajit? ( dev-lang/luajit )
	!luajit? ( dev-lang/lua:= )
	mysql? ( dev-db/mysql-connector-c )
	ncurses? ( sys-libs/ncurses:= )
	pulseaudio? ( media-sound/pulseaudio )
	rss? ( dev-libs/libxml2 net-misc/curl dev-libs/glib:2 )
	systemd? ( sys-apps/systemd )
	wifi? ( net-wireless/wireless-tools )
	weather-metar? ( net-misc/curl )
	webserver? ( net-libs/libmicrohttpd )
"
RDEPEND="
	${COMMON_DEPEND}
	apcupsd? ( sys-power/apcupsd )
	hddtemp? ( app-admin/hddtemp )
	moc? ( media-sound/moc )
	nano-syntax? ( app-editors/nano )
	vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )
"
DEPEND="
	${COMMON_DEPEND}
	app-text/docbook2X
"

REQUIRED_USE="
	imlib? ( X )
	nvidia? ( X )
	truetype? ( X )
	lua-cairo? ( X )
	lua-imlib? ( X )
	lua-rsvg? ( X )
"
CONFIG_CHECK=~IPV6

DOCS=( README.md AUTHORS )

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="You can find sample configurations at ${ROOT}/usr/share/doc/${PF}.
To customize, copy to \${XDG_CONFIG_HOME}/conky/conky.conf
and edit it to your liking.

There are pretty html docs available at the conky homepage
or in \"${ROOT}/usr/share/doc/${PF}/html\".

Also see https://wiki.gentoo.org/wiki/Conky/HOWTO"

pkg_setup() {
	use ipv6 && linux-info_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	xdg_environment_reset

	local lua_pkgconfig="lua"
	if use luajit; then
		lua_pkgconfig="luajit"
	fi
	sed -i -e "s|find_program(APP_MAN man)|set(APP_MAN $(which man) CACHE FILEPATH MAN_BINARY)|" \
		-e "s/lua>=5.3/${lua_pkgconfig} lua>=5.3/" \
		cmake/ConkyPlatformChecks.cmake || die
	sed -i -e 's/set(CMAKE_C_FLAGS "/set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /' \
		-e 's/set(CMAKE_CXX_FLAGS "/set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /' \
		cmake/ConkyBuildOptions.cmake || die
}

src_configure() {
	local mycmakeargs

	if use X; then
		mycmakeargs=(
			-DBUILD_X11=ON
			-DOWN_WINDOW=ON
			-DBUILD_XDAMAGE=ON
			-DBUILD_XINERAMA=ON
			-DBUILD_XDBE=ON
			-DBUILD_XFT=$(usex truetype)
			-DBUILD_IMLIB2=$(usex imlib)
			-DBUILD_XSHAPE=ON
			-DBUILD_ARGB=ON
			-DBUILD_LUA_CAIRO=$(usex lua-cairo)
			-DBUILD_LUA_IMLIB2=$(usex lua-imlib)
			-DBUILD_LUA_RSVG=$(usex lua-rsvg)
			-DBUILD_NVIDIA=$(usex nvidia)
			-DBUILD_XMMS2=$(usex xmms2)
		)
	else
		mycmakeargs=(
			-DBUILD_X11=OFF
			-DBUILD_NVIDIA=OFF
			-DBUILD_LUA_CAIRO=OFF
			-DBUILD_LUA_IMLIB2=OFF
			-DBUILD_LUA_RSVG=OFF
			-DBUILD_XMMS2=OFF
		)
	fi

	mycmakeargs+=(
		-DBUILD_APCUPSD=$(usex apcupsd)
		-DBUILD_CMUS=$(usex cmus)
		-DBUILD_CURL=$(usex curl)
		-DBUILD_HDDTEMP=$(usex hddtemp)
		-DBUILD_IOSTATS=$(usex iostats)
		-DBUILD_ICAL=$(usex ical)
		-DBUILD_ICONV=$(usex iconv)
		-DBUILD_IPV6=$(usex ipv6)
		-DBUILD_IRC=$(usex irc)
		-DBUILD_MATH=$(usex math)
		-DBUILD_MOC=$(usex moc)
		-DBUILD_MPD=$(usex mpd)
		-DBUILD_MYSQL=$(usex mysql)
		-DBUILD_NCURSES=$(usex ncurses)
		-DBUILD_PORT_MONITORS=$(usex portmon)
		-DBUILD_PULSEAUDIO=$(usex pulseaudio)
		-DBUILD_RSS=$(usex rss)
		-DBUILD_JOURNAL=$(usex systemd)
		-DBUILD_IBM=$(usex thinkpad)
		-DBUILD_HTTP=$(usex webserver)
		-DBUILD_WEATHER_METAR=$(usex weather-metar)
		-DBUILD_WLAN=$(usex wifi)
		-DBUILD_BUILTIN_CONFIG=ON
		-DBUILD_OLD_CONFIG=ON
		-DBUILD_I18N=ON
		-DRELEASE=ON
		-DBUILD_AUDACIOUS=OFF
		-DDOC_PATH=/usr/share/doc/${PF}
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/ftdetect
		doins "${S}"/extras/vim/ftdetect/conkyrc.vim

		insinto /usr/share/vim/vimfiles/syntax
		doins "${S}"/extras/vim/syntax/conkyrc.vim
	fi

	if use nano-syntax; then
		insinto /usr/share/nano/
		doins "${S}"/extras/nano/conky.nanorc
	fi

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog

	xdg_pkg_postinst
}
