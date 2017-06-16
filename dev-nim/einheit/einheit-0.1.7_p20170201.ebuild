# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Nim unit test library"
HOMEPAGE="https://github.com/jyapayne/einheit"
EGIT_REPO_URI="https://github.com/jyapayne/einheit"
EGIT_COMMIT="50ce1eca9724b7e635390264fe0dadafb5966323"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="
	>=dev-lang/nim-0.11.3
"
RDEPEND="${DEPEND}"

src_test() {
	nim c -r tests/test.nim
}

src_install() {
	dodir /usr/share/nim/lib/packages
	insinto /usr/share/nim/lib/packages
	doins -r src/*
}
