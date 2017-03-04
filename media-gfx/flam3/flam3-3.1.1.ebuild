# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="Tools and a library for creating flame fractal images"
HOMEPAGE="http://flam3.com/"
SRC_URI="https://github.com/scottdraves/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RDEPEND="dev-libs/libxml2
	media-libs/libpng:*
	virtual/jpeg:*"
DEPEND="${RDEPEND}"

DOCS=( README.txt )

src_prepare() {
	default

	sed -e "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/" -i configure.ac || die
	eautoreconf
}

src_configure() {
	econf \
		--enable-shared \
		$(use_enable static-libs static)
}

src_install() {
	default

	rm -f "${D}"usr/lib*/libflam3.la

	docinto examples
	dodoc *.flam3
}
