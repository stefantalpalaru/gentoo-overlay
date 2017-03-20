# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="IRC client module for Nim"
HOMEPAGE="https://github.com/nim-lang/irc"
EGIT_REPO_URI="https://github.com/nim-lang/irc"
EGIT_COMMIT="d57745d510ad6a16538dafa2a09c5199c3088b04"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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
