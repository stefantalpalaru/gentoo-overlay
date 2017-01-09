# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3

DESCRIPTION="Nim package manager"
HOMEPAGE="https://github.com/nim-lang/nimble"
EGIT_REPO_URI="https://github.com/nim-lang/nimble"
EGIT_COMMIT="refs/tags/v${PV}"
EGIT_CLONE_TYPE="shallow"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="
	>=dev-lang/nim-0.13.0
"
RDEPEND=""

src_compile() {
	nim c -d:release src/${PN}.nim || die "compile failed"
}

src_test() {
	nim c -d:release tests/tester.nim || die "tester.nim compile failed"
	cd tests
	./tester
}

src_install() {
	dodir /usr/bin
	exeinto /usr/bin
	doexe src/${PN}
}
