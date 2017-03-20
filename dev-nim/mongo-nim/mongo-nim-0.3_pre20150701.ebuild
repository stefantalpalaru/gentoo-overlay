# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Nim bindings for MongoDB"
HOMEPAGE="https://github.com/nim-lang/mongo"
EGIT_REPO_URI="https://github.com/nim-lang/mongo"
EGIT_COMMIT="a78161f8a89d950fa9102cff2a09d3b3863b9213"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-db/mongodb
	>=dev-lang/nim-0.10.2
"
RDEPEND=""

src_install() {
	dodir /usr/share/nim/lib/packages/mongo
	insinto /usr/share/nim/lib/packages/mongo
	doins -r lib/*
}
