# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic git-r3

DESCRIPTION="a library exposing Go's channels and goroutines to plain C"
HOMEPAGE="https://github.com/stefantalpalaru/golib"
EGIT_REPO_URI="https://github.com/stefantalpalaru/golib"
EGIT_COMMIT="27504f74419db5efcff0dc9674166c3e6908529f"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs test"
RESTRICT="
	strip
	!test? ( test )
"

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
