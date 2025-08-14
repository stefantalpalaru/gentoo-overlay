# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edos2unix cmake

DESCRIPTION="Spam-resistant message board application for Freenet"
# FMS only has a homepage within Freenet, so the closest is a wiki linking to it
HOMEPAGE="https://github.com/hyphanet/wiki/wiki/FMS"
# "max-size" needs to be larger than archive size, in bytes
SRC_URI="http://127.0.0.1:8888/CHK@ZndjoXMPzYxVTxhfpAzBMKlLYfQ~LjlDz-~N9xGB-JE,HhAoviqsLgsasYAEGPdDY3ZeeMfJa0QbIfLby8YjxEI,AAMC--8/fms-src-${PV}.zip?type=application/x-zip-compressed&max-size=10000000&force=ecc7215efe7d18f2421a3f5c684c7dd834212f00ee3ee4c3e2765fa712ad66af -> fms-src-${PV}.zip"
S="${WORKDIR}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="frost ssl"
#RESTRICT="fetch"

CDEPEND="
	acct-group/freenet
	acct-user/freenet
"

RDEPEND="
	${CDEPEND}
	dev-db/sqlite:3=
	dev-libs/poco
	frost? ( net-libs/mbedtls:0= )
	ssl? ( net-libs/mbedtls:0= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	${CDEPEND}
	app-arch/unzip
	virtual/libiconv
"

PATCHES=(
	"${FILESDIR}/${PN}-use-system-libs4.patch"
	"${FILESDIR}/${PN}-0.3.83-fix-for-mbedtls-3.patch"
)

DOCS=( "readme.txt" )

pkg_nofetch() {
	einfo "Please make sure Freenet is up and running, then download FMS from"
	einfo "${SRC_URI}"
	einfo "(it only works in a browser)"
	einfo "and place the file in your DISTDIR directory."
	einfo
}

src_prepare() {
	# Convert encoding due applied patch
	edos2unix src/http/pages/showfilepage.cpp
	edos2unix CMakeLists.txt
	edos2unix include/freenet/fcpv2.h

	# Remove bundled libs
	rm -fr libs || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DDO_CHARSET_CONVERSION="ON"
		-DFCP_SSL_SUPPORT="$(usex ssl 'ON' 'OFF')"
		-DFROST_SUPPORT="$(usex frost 'ON' 'OFF')"
		-DI_HAVE_READ_THE_README="ON"
		-DUSE_BUNDLED_SQLITE="OFF"
	)

	cmake_src_configure
}

src_install() {
	dobin "${BUILD_DIR}"/fms

	insinto /var/freenet/fms
	doins *.htm
	doins -r fonts images styles translations

	fperms -R o-rwx /var/freenet/fms
	fowners -R freenet:freenet /var/freenet/fms

	newinitd "${FILESDIR}/fms.initd" fms

	einstalldocs
}

pkg_postinst() {
	if ! has_version 'net-p2p/freenet' ; then
		ewarn "FMS needs a freenet node to upload and download messages."
		ewarn "Please make sure to have a node you can connect to"
		ewarn "or install net-p2p/freenet to get FMS working."
	fi

	einfo "By default, the FMS NNTP server will listen on port 1119,"
	einfo "and the web configuration interface will be running at"
	einfo "http://localhost:8080."
	einfo "For more information, read the installed readme.txt."

	if use frost; then
		einfo
		einfo "You need to enable frost on the configuration page"
		einfo "and restart FMS for frost support."
	fi
}
