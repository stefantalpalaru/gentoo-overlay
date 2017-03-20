# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Nim bindings for OpenGL"
HOMEPAGE="https://github.com/nim-lang/opengl"
SRC_URI="https://github.com/nim-lang/opengl/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>dev-lang/nim-0.10.3
	dev-nim/x11-nim
	virtual/opengl
"
RDEPEND=""

S="${WORKDIR}/opengl-${PV}"

src_install() {
	dodir /usr/share/nim/lib/packages/opengl
	insinto /usr/share/nim/lib/packages/opengl
	doins -r src/*
}
