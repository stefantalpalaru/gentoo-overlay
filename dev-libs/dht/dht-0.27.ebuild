# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="BitTorrent DHT library"
HOMEPAGE="https://github.com/jech/dht"
SRC_URI="https://github.com/jech/dht/archive/refs/tags/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86"
IUSE="static-libs"

S="${WORKDIR}/dht-${P}"

src_prepare() {
	default

	mkdir -p include/dht
	cp -a dht.h include/dht/ || die
}

src_compile() {
	libtool --mode=compile "$(tc-getCC)" ${CFLAGS} -I../include -c dht.c || die
	libtool --mode=link "$(tc-getCC)" -o libdht.la dht.lo ${LDFLAGS} -rpath "/usr/$(get_libdir)" -version-info 0:27:0 || die
}

src_install() {
	dolib.so .libs/libdht.so*
	if use static-libs; then
		dolib.a .libs/libdht.a
	fi
	insinto /usr/include
	doins -r include/dht
	einstalldocs
}
