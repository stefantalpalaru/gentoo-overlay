# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Finite State Transducer tools by Google et al"
HOMEPAGE="https://www.openfst.org/twiki/bin/view/FST/WebHome"
SRC_URI="http://www.openfst.org/twiki/pub/FST/FstDownload/${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

src_configure() {
	local myeconfargs=(
		--enable-bin
		--enable-compact-fsts
		--enable-compress
		--enable-const-fsts
		--enable-far
		--enable-grm
		--enable-linear-fsts
		--enable-lookahead-fsts
		--enable-mpdt
		--enable-ngram-fsts
		--enable-pdt
		--enable-special
	)
	econf ${myeconfargs[@]}
}
