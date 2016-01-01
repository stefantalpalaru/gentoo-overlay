# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3

DESCRIPTION="Nim bindings for X11"
HOMEPAGE="https://github.com/nim-lang/x11"
EGIT_REPO_URI="https://github.com/nim-lang/x11"
EGIT_CLONE_TYPE="shallow"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>dev-lang/nim-0.9.2
	x11-libs/libX11
"
RDEPEND=""

src_install() {
	dodir /usr/share/nim/lib/packages/x11
	insinto /usr/share/nim/lib/packages/x11
	doins -r src/*
}
