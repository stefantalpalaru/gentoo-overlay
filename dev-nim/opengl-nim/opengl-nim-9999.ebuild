# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3

DESCRIPTION="Nim bindings for OpenGL"
HOMEPAGE="https://github.com/nim-lang/opengl"
EGIT_REPO_URI="https://github.com/nim-lang/opengl"
EGIT_CLONE_TYPE="shallow"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>dev-lang/nim-0.9.2
	dev-nim/x11-nim
	virtual/opengl
"
RDEPEND=""

src_install() {
	dodir /usr/share/nim/lib/packages/opengl
	insinto /usr/share/nim/lib/packages/opengl
	doins -r src/*
}
