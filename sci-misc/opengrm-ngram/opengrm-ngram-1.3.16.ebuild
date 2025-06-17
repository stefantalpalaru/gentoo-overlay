# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="n-gram language models encoded as weighted finite-state transducers"
HOMEPAGE="https://www.opengrm.org/twiki/bin/view/GRM/NGramLibrary"
SRC_URI="https://www.opengrm.org/twiki/pub/GRM/NGramDownload/ngram-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/ngram-${PV}"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

RDEPEND=">=sci-misc/openfst-1.5.2"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	sed -i -e "s:/usr/local/lib:/usr/$(get_libdir):" \
		src/bin/Makefile.am \
		src/test/Makefile.am
	eautoreconf
}
