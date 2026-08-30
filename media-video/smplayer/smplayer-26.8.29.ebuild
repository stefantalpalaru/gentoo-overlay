# Copyright 2007-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic optfeature qmake-utils toolchain-funcs xdg

DESCRIPTION="Great Qt GUI front-end for mplayer/mpv"
HOMEPAGE="https://www.smplayer.info/"
SRC_URI="https://github.com/smplayer-dev/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2+ BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
IUSE="bidi debug"

DEPEND="
	dev-qt/qt5compat:6
	dev-qt/qtbase:6=[dbus,gui,network,ssl,widgets,xml]
	dev-qt/qtdeclarative:6
	virtual/zlib:=
	x11-libs/libX11
"
RDEPEND="
	${DEPEND}
	|| (
		media-video/mpv[libass(+),X]
		media-video/mplayer[bidi?,libass,png,X]
	)
"
BDEPEND="dev-qt/qttools:6[linguist]"

PATCHES=(
	"${FILESDIR}"/smplayer-17.1.0-advertisement_crap.patch
	"${FILESDIR}"/smplayer-18.2.0-jobserver.patch
	"${FILESDIR}"/smplayer-18.3.0-disable-werror.patch
	"${FILESDIR}"/smplayer-25.6.0_p20250903-disable-update-checker.patch #bug #479902
	"${FILESDIR}"/smplayer-25.6.0_p20250903-no-man-compress.patch
	"${FILESDIR}"/smplayer-25.6.0_p20250903-no-googledns.patch # thx to Debian
	"${FILESDIR}"/smplayer-26.8.29-qml.patch
	"${FILESDIR}"/smplayer-26.8.29-qt6.patch
)

src_prepare() {
	use bidi || PATCHES+=( "${FILESDIR}"/${PN}-16.4.0-zero-bidi.patch )

	default

	# Upstream Makefile sucks
	sed -i -e "/^PREFIX=/ s:/usr/local:${EPREFIX}/usr:" \
		-e "/^DOC_PATH=/ s:packages/smplayer:"${PF}":" \
		-e '/\.\/get_svn_revision\.sh/,+2c\
	cd src && $(DEFS) $(MAKE)' \
		Makefile || die

	# Turn debug message flooding off
	if ! use debug ; then
		sed -e 's:#\(DEFINES += NO_DEBUG_ON_CONSOLE\):\1:' \
			-i src/smplayer.pro || die
	fi

	append-cxxflags -fpermissive
}

src_configure() {
	pushd src > /dev/null || die
		eqmake6 QT_MAJOR_VERSION=6
	popd > /dev/null || die
}

src_compile() {
	emake CC="$(tc-getCC)"

	pushd src/translations > /dev/null || die
		$(qt6_get_bindir)/lrelease smplayer_*.ts
	popd > /dev/null || die
}

src_install() {
	# remove unneeded copies of the GPL
	rm Copying* docs/*/gpl.html || die
	# don't install empty dirs
	rmdir --ignore-fail-on-non-empty docs/* || die

	default
}

pkg_postinst() {
	xdg_pkg_postinst
	optfeature "URL support with media-video/mpv" net-misc/yt-dlp
}
