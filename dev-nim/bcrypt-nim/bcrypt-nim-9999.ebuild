# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3

DESCRIPTION="Nim bindings for bcrypt"
HOMEPAGE="https://github.com/runvnc/bcryptnim"
EGIT_REPO_URI="https://github.com/runvnc/bcryptnim"
EGIT_CLONE_TYPE="shallow"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>=dev-lang/nim-0.9.2
"
RDEPEND=""

src_install() {
	dodir /usr/share/nim/lib/packages/bcrypt
	insinto /usr/share/nim/lib/packages/bcrypt
	doins *.h *.c *.nim
}
