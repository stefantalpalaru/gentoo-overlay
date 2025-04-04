# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Nim package manager"
HOMEPAGE="https://github.com/nim-lang/nimble"
EGIT_REPO_URI="https://github.com/nim-lang/nimble"
EGIT_COMMIT="v${PV}"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-lang/nim-1.6.20
"

PATCHES=(
	"${FILESDIR}"/nimble-0.16.4-import.patch
)

src_compile() {
	nim c -d:release -p:"\$lib/packages/compiler" --verbosity:2 src/${PN}.nim || die "compile failed"
}

src_test() {
	nim c -d:release -p:"\$lib/packages/compiler" --verbosity:2 tests/tester.nim || die "tester.nim compile failed"
	cd tests
	./tester
}

src_install() {
	exeinto /usr/bin
	doexe src/${PN}
}
