# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3

DESCRIPTION="Nim bindings for ZeroMQ"
HOMEPAGE="https://github.com/nim-lang/nim-zmq"
EGIT_REPO_URI="https://github.com/nim-lang/nim-zmq"
EGIT_CLONE_TYPE="shallow"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>=dev-lang/nim-0.9.6
	net-libs/zeromq
"
RDEPEND=""

src_install() {
	dodir /usr/share/nim/lib/packages/zmq
	insinto /usr/share/nim/lib/packages/zmq
	doins zmq.nim
}
