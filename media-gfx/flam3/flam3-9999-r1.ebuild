# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools git-r3

DESCRIPTION="Tools and a library for creating fractal flames"
HOMEPAGE="http://flam3.com/"
EGIT_REPO_URI="https://github.com/scottdraves/flam3"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
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
