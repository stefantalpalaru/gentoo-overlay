# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="portable dialogs for Nim"
HOMEPAGE="https://github.com/nim-lang/dialogs"
SRC_URI="https://github.com/nim-lang/dialogs/archive/v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=dev-lang/nim-0.10.0
	>=dev-nim/gtk2-nim-1.0
"
RDEPEND=""

src_install() {
	dodir /usr/share/nim/lib/packages/${PN}
	insinto /usr/share/nim/lib/packages/${PN}
	doins ${PN}.nim
}
