# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="IDE for the Nim programming language"
HOMEPAGE="https://github.com/nim-lang/Aporia"
SRC_URI="https://github.com/nim-lang/Aporia/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=dev-lang/nim-0.11.0
	x11-libs/gtksourceview
	dev-libs/libpcre
	dev-nim/dialogs
	dev-nim/gtk2-nim
"
RDEPEND=""

S="${WORKDIR}/Aporia-${PV}"

src_compile() {
	nim c -d:release -p:"\$lib/packages/gtk2" -p:"\$lib/packages/cairo" -p:"\$lib/packages/dialogs" ${PN}.nim || die "compile failed"
}

src_install() {
	dodir /usr/bin
	exeinto /usr/bin
	doexe ${PN}
}
