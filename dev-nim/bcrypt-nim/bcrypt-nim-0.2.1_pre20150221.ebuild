# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Nim bindings for bcrypt"
HOMEPAGE="https://github.com/runvnc/bcryptnim"
EGIT_REPO_URI="https://github.com/runvnc/bcryptnim"
EGIT_COMMIT="a4e47bf75d11484c3d00c6b1930618376282e929"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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
