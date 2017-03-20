# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Nim bindings for lthread"
HOMEPAGE="https://github.com/stefantalpalaru/lthread-nim"
EGIT_REPO_URI="https://github.com/stefantalpalaru/lthread-nim"
EGIT_COMMIT="de765529bf1aefcf43238044958bb85defbf39f9"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-lang/nim
	dev-libs/lthread
"
RDEPEND=""

src_install() {
	dodir /usr/share/nim/lib/packages/lthread
	insinto /usr/share/nim/lib/packages/lthread
	doins -r src/*
}
