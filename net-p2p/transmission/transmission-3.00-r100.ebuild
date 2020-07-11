# Copyright 2006-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3 systemd xdg-utils

DESCRIPTION="A fast, easy, and free BitTorrent client"
HOMEPAGE="https://transmissionbt.com/"
EGIT_REPO_URI="https://github.com/transmission/transmission"
EGIT_COMMIT="${PV}"
EGIT_SUBMODULES=(
	'*'
	'-third-party/libb64'
	'-third-party/libevent'
	'-third-party/libnatpmp'
	'-third-party/miniupnpc'
)

# web/LICENSE is always GPL-2 whereas COPYING allows either GPL-2 or GPL-3 for the rest
# transmission in licenses/ is for mentioning OpenSSL linking exception
# MIT is in several libtransmission/ headers
LICENSE="|| ( GPL-2 GPL-3 Transmission-OpenSSL-exception ) GPL-2 MIT"
SLOT="0"
IUSE="appindicator cli doc gtk libressl lightweight nls mbedtls qt5 systemd test"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86 ~amd64-linux"
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
	!mbedtls? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	mbedtls? ( net-libs/mbedtls:0= )
	dev-libs/libb64
	net-libs/libnatpmp
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

PATCHES=(
	"${FILESDIR}/default_trackers-r3.patch"
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR=share/doc/${PF}

		-DENABLE_GTK=$(usex gtk ON OFF)
		-DENABLE_QT=$(usex qt5 ON OFF)
		-DENABLE_CLI=$(usex cli ON OFF)
		-DENABLE_TESTS=$(usex test ON OFF)
		-DENABLE_LIGHTWEIGHT=$(usex lightweight)
		-DENABLE_NLS=$(usex nls ON OFF)
		-DINSTALL_DOC=$(usex doc ON OFF)
		-DUSE_SYSTEM_EVENT2=ON
		-DUSE_SYSTEM_DHT=OFF
		-DUSE_SYSTEM_MINIUPNPC=ON
		-DUSE_SYSTEM_NATPMP=ON
		-DUSE_SYSTEM_UTP=OFF
		-DUSE_SYSTEM_B64=ON
		-DWITH_CRYPTO=$(usex mbedtls polarssl openssl)
		-DWITH_INOTIFY=ON
		-DWITH_LIBAPPINDICATOR=$(usex appindicator ON OFF)
		-DWITH_SYSTEMD=$(usex systemd ON OFF)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	newinitd "${FILESDIR}"/transmission-daemon.initd.10 transmission-daemon
	newconfd "${FILESDIR}"/transmission-daemon.confd.4 transmission-daemon
	if use systemd; then
		systemd_dounit daemon/transmission-daemon.service
		systemd_install_serviced "${FILESDIR}"/transmission-daemon.service.conf
	fi

	insinto /usr/lib/sysctl.d
	doins "${FILESDIR}"/60-transmission.conf

	if [[ ${EUID} == 0 ]]; then
		diropts -o transmission -g transmission
	fi
	keepdir /var/lib/transmission
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
