# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Nim bindings for dev-libs/chan"
HOMEPAGE="https://github.com/stefantalpalaru/chan-nim"
EGIT_REPO_URI="https://github.com/stefantalpalaru/chan-nim"
EGIT_COMMIT="c212078817d438361bd0b5db755885177814bd25"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-lang/nim
	dev-libs/chan
"
RDEPEND="${DEPEND}"

src_install() {
	dodir /usr/share/nim/lib/packages/chan
	insinto /usr/share/nim/lib/packages/chan
	doins -r src/*
}
