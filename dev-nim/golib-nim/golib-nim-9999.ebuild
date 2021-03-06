# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Nim bindings for golib"
HOMEPAGE="https://github.com/stefantalpalaru/golib-nim"
EGIT_REPO_URI="https://github.com/stefantalpalaru/golib-nim"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>=dev-lang/nim-0.13.0
	dev-libs/golib
"
RDEPEND=""

src_install() {
	dodir /usr/share/nim/lib/packages/golib
	insinto /usr/share/nim/lib/packages/golib
	doins -r src/*
}
