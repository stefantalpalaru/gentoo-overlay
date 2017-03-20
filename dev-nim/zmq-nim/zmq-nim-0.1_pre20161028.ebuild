# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Nim bindings for ZeroMQ"
HOMEPAGE="https://github.com/nim-lang/nim-zmq"
EGIT_REPO_URI="https://github.com/nim-lang/nim-zmq"
EGIT_COMMIT="a9f7db68659d9720bbf0cc665ae70a3e989ad1b0"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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
