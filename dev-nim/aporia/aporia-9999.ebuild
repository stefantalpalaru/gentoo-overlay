# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-r3

DESCRIPTION="IDE for the Nim programming language"
HOMEPAGE="https://github.com/nim-lang/Aporia"
EGIT_REPO_URI="https://github.com/nim-lang/Aporia"
EGIT_CLONE_TYPE="shallow"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>=dev-lang/nim-0.9.2
	x11-libs/gtksourceview
	dev-libs/libpcre
	dev-nim/gtk2-nim
"
RDEPEND=""

src_compile() {
	nim c -d:release -p:"\$lib/packages/gtk2" -p:"\$lib/packages/cairo" ${PN}.nim || die "compile failed"
}

src_install() {
	dodir /usr/bin
	exeinto /usr/bin
	doexe ${PN}
}
