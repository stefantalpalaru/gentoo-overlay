# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Nim bindings for GTK+ 2"
HOMEPAGE="https://github.com/nim-lang/gtk2"
SRC_URI="https://github.com/nim-lang/gtk2/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>dev-lang/nim-0.9.2
	dev-nim/cairo-nim
	x11-libs/gtk+:2
"
RDEPEND=""

src_install() {
	dodir /usr/share/nim/lib/packages/gtk2
	insinto /usr/share/nim/lib/packages/gtk2
	doins -r src/*
}
