# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3

DESCRIPTION="Nim bindings for dev-libs/chan"
HOMEPAGE="https://github.com/stefantalpalaru/chan-nim"
EGIT_REPO_URI="https://github.com/stefantalpalaru/chan-nim"
EGIT_CLONE_TYPE="shallow"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-lang/nim
	dev-libs/chan
"
RDEPEND=""

src_install() {
	dodir /usr/share/nim/lib/packages/chan
	insinto /usr/share/nim/lib/packages/chan
	doins -r src/*
}
