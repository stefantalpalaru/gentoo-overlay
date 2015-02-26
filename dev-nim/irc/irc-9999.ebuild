# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-r3

DESCRIPTION="IRC client module for Nim"
HOMEPAGE="https://github.com/nim-lang/irc"
EGIT_REPO_URI="https://github.com/nim-lang/irc"
EGIT_CLONE_TYPE="shallow"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>=dev-lang/nim-0.9.5
"
RDEPEND=""

src_install() {
	dodir /usr/share/nim/lib/packages/irc
	insinto /usr/share/nim/lib/packages/irc
	doins -r src/*
}
