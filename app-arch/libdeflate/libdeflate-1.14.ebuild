# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Heavily optimized DEFLATE/zlib/gzip (de)compression"
HOMEPAGE="https://github.com/ebiggers/libdeflate"
SRC_URI="https://github.com/ebiggers/libdeflate/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86 ~amd64-linux"

LICENSE="MIT"
SLOT="0"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

src_compile() {
	emake V=1
}

src_install() {
	emake DESTDIR="${ED}" PREFIX=/usr LIBDIR="/usr/$(get_libdir)" V=1 install
	if ! use static-libs; then
		find "${ED}" -name '*.a' -delete || die
	fi
	dodoc NEWS.md README.md
}
