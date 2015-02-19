# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-r3

DESCRIPTION="a tool to translate Ansi C code to Nim"
HOMEPAGE="https://github.com/nim-lang/c2nim"
EGIT_REPO_URI="https://github.com/nim-lang/c2nim"
EGIT_CLONE_TYPE="shallow"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc test"

DEPEND="
	>=dev-lang/nim-0.10.3
"
RDEPEND=""

src_compile() {
	nim c -d:release c2nim.nim
}

src_test() {
	nim c -d:release testsuite/tester.nim
	PATH=".:${PATH}" ./testsuite/tester
}

src_install() {
	dodir /usr/bin
	exeinto /usr/bin
	doexe c2nim

	if use doc; then
		dodoc doc/c2nim.txt
	fi
}

