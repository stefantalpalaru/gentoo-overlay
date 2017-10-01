# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Extract a plain text corpus from MediaWiki XML dumps, such as Wikipedia."
HOMEPAGE="https://github.com/rspeer/wiki2text"
SRC_URI="https://github.com/rspeer/wiki2text/archive/v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=dev-lang/nim-0.11
"
RDEPEND="${DEPEND}"

src_compile() {
	nim c -d:release ${PN}.nim || die "compile failed"
}

src_install() {
	dodir /usr/bin
	exeinto /usr/bin
	doexe ${PN}
}
