# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Nim package manager"
HOMEPAGE="https://github.com/nim-lang/nimble"
SRC_URI="https://github.com/nim-lang/nimble/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="
	>=dev-lang/nim-0.13.0
"
RDEPEND=""

src_compile() {
	nim c -d:release -p:"\$lib/packages/compiler" --verbosity:2 src/${PN}.nim || die "compile failed"
}

src_test() {
	nim c -d:release -p:"\$lib/packages/compiler" --verbosity:2 tests/tester.nim || die "tester.nim compile failed"
	cd tests
	./tester
}

src_install() {
	dodir /usr/bin
	exeinto /usr/bin
	doexe src/${PN}
}
