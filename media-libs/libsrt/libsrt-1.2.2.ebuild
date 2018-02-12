# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Secure Reliable Transport - video transport protocol"
HOMEPAGE="https://www.srtalliance.org/"
SRC_URI="https://github.com/Haivision/srt/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnutls"

RDEPEND="
	!gnutls? (
		dev-libs/openssl:0
		sys-libs/zlib
	)
	gnutls? (
		dev-libs/nettle
		net-libs/gnutls
	)
"
DEPEND="${RDEPEND}"

S=${WORKDIR}/srt-${PV}

src_prepare() {
	default

	sed -i -e "s/DESTINATION lib/DESTINATION $(get_libdir)/" \
		CMakeLists.txt

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DUSE_GNUTLS=$(usex gnutls ON OFF)
	)
	cmake-utils_src_configure
}
