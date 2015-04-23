# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools-utils flag-o-matic git-r3

DESCRIPTION="a library exposing Go's channels and goroutines to plain C"
HOMEPAGE="https://github.com/stefantalpalaru/golib"
EGIT_REPO_URI="https://github.com/stefantalpalaru/golib"
EGIT_CLONE_TYPE="shallow"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE="static-libs test"
RESTRICT="strip"

DEPEND="sys-devel/gcc[go]"
RDEPEND=""

src_prepare() {
	eautoreconf
}

src_compile() {
	filter-ldflags -s
	autotools-utils_src_compile
}

src_install() {
	DOCS=""
	autotools-utils_src_install
}
