# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Google's open source finite-state n-gram library"
HOMEPAGE="http://openfst.cs.nyu.edu/twiki/bin/view/GRM/NGramLibrary"
SRC_URI="http://openfst.cs.nyu.edu/twiki/pub/GRM/NGramDownload/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sci-misc/openfst-1.5.2"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	sed -i -e "s:/usr/local/lib:/usr/$(get_libdir):" \
		src/bin/Makefile.am \
		src/test/Makefile.am
	eautoreconf
}
