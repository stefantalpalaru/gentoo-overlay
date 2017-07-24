# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic git-r3

DESCRIPTION="a library exposing Go's channels and goroutines to plain C"
HOMEPAGE="https://github.com/stefantalpalaru/golib"
EGIT_REPO_URI="https://github.com/stefantalpalaru/golib"
EGIT_COMMIT="3c8ea37f49961c01d012f9f848baaa965ae61680"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs test"
RESTRICT="strip"

DEPEND="sys-devel/gcc:=[go]"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_compile() {
	filter-ldflags -s
	default
}

src_install() {
	DOCS=""
	default
	prune_libtool_files
}
