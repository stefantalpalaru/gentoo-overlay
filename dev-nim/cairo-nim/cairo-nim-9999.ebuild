# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Nim bindings for cairo"
HOMEPAGE="https://github.com/nim-lang/cairo"
EGIT_REPO_URI="https://github.com/nim-lang/cairo"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>dev-lang/nim-0.9.2
	x11-libs/cairo
"
RDEPEND="${DEPEND}"

src_install() {
	dodir /usr/share/nim/lib/packages/cairo
	insinto /usr/share/nim/lib/packages/cairo
	doins -r src/*
}
