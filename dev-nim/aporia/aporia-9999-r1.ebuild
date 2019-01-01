# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="IDE for the Nim programming language"
HOMEPAGE="https://github.com/nim-lang/Aporia"
EGIT_REPO_URI="https://github.com/nim-lang/Aporia"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>=dev-lang/nim-0.11.0
	x11-libs/gtksourceview:2.0
	dev-libs/libpcre
	>=dev-nim/dialogs-1.1.1
	>=dev-nim/gtk2-nim-1.3
"
RDEPEND=""

src_compile() {
	nim c -d:release --verbosity:2 --nilseqs:on -p:"\$lib/packages/gtk2" -p:"\$lib/packages/cairo" -p:"\$lib/packages/dialogs" ${PN}.nim || die "compile failed"
}

src_install() {
	dodir /usr/bin
	exeinto /usr/bin
	doexe ${PN}
}
