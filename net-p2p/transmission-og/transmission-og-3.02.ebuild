# Copyright 2006-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic systemd xdg-utils

DESCRIPTION="Transmission 3.00 fork (BitTorrent client)"
HOMEPAGE="https://github.com/stefantalpalaru/transmission-og"
SRC_URI="https://github.com/stefantalpalaru/transmission-og/releases/download/${PV}/${P}.tar.xz"

# web/LICENSE is always GPL-2 whereas COPYING allows either GPL-2 or GPL-3 for the rest.
# "Transmission-..." in licenses/ is for mentioning an OpenSSL linking exception.
# MIT is in several libtransmission/ headers.
LICENSE="|| ( GPL-2 GPL-3 Transmission-OpenSSL-exception ) GPL-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="appindicator doc gtk lightweight nls mbedtls qt5 static-libs systemd test"
RESTRICT="!test? ( test )"

ACCT_DEPEND="
	acct-group/transmission
	acct-user/transmission
"
BDEPEND="${ACCT_DEPEND}
	virtual/pkgconfig
	nls? (
		gtk? (
			dev-util/intltool
			sys-devel/gettext
		)
		qt5? (
			dev-qt/linguist-tools:5
		)
	)
"
COMMON_DEPEND="
	>=dev-libs/libevent-2.0.10:=
	!mbedtls? ( dev-libs/openssl:0=	)
	mbedtls? ( net-libs/mbedtls:0= )
	dev-libs/dht
	dev-libs/libb64
	net-libs/libnatpmp
	net-libs/libutp
	>=net-libs/miniupnpc-1.7:=
	>=net-misc/curl-7.15.4[ssl]
	sys-libs/zlib:=
	nls? ( virtual/libintl )
	gtk? (
		>=dev-libs/dbus-glib-0.100
		>=dev-libs/glib-2.32:2
		>=x11-libs/gtk+-3.4:3
		appindicator? ( >=dev-libs/libappindicator-0.4.90:3 )
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
	)
	systemd? ( >=sys-apps/systemd-209:= )
"
DEPEND="${COMMON_DEPEND}
	nls? (
		virtual/libintl
		gtk? (
			dev-util/intltool
			sys-devel/gettext
		)
		qt5? (
			dev-qt/linguist-tools:5
		)
	)
"
RDEPEND="${COMMON_DEPEND}
	${ACCT_DEPEND}
"

REQUIRED_USE="appindicator? ( gtk )"

src_configure() {
	append-cppflags "-DNDEBUG"

	local myeconfargs=(
		$(use_enable lightweight)
		$(use_enable nls)
		$(use_enable static-libs static)
		$(use_with gtk)
		$(use_with qt5 qt)
		$(use_with systemd)
		--enable-cli
		--enable-external-b64
		--enable-external-dht
		--enable-external-libevent
		--enable-external-miniupnpc
		--enable-external-natpmp
		--enable-external-utp
		--with-crypto=$(usex mbedtls polarssl openssl)
		--with-inotify
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" install

	if ! use static-libs; then
		find "${ED}" -type f -name '*.la' -delete || die
	fi

	newinitd "${FILESDIR}"/transmission-og-daemon.initd.10 transmission-og-daemon
	newconfd "${FILESDIR}"/transmission-og-daemon.confd.4 transmission-og-daemon

	if use systemd; then
		systemd_dounit daemon/transmission-og-daemon.service
		systemd_install_serviced "${FILESDIR}"/transmission-og-daemon.service.conf
	fi

	insinto /usr/lib/sysctl.d
	doins "${FILESDIR}"/60-transmission-og.conf
}

pkg_postrm() {
	if use gtk || use qt5; then
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi
}

pkg_postinst() {
	if use gtk || use qt5; then
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi
}
