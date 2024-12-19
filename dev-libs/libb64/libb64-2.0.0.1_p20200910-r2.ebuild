# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
MY_COMMIT="ce864b17ea0e24a91e77c7dd3eb2d1ac4175b3f0"

inherit toolchain-funcs

DESCRIPTION="Fast Base64 encoding/decoding routines"
HOMEPAGE="https://github.com/libb64/libb64/"
SRC_URI="https://github.com/libb64/libb64/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/libb64-${MY_COMMIT}"
LICENSE="CC-PD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86"
IUSE="static-libs"

src_compile() {
	cd src
	libtool --mode=compile "$(tc-getCC)" ${CFLAGS} -I../include -c cencode.c || die
	libtool --mode=compile "$(tc-getCC)" ${CFLAGS} -I../include -c cdecode.c || die
	libtool --mode=link "$(tc-getCC)" -o libb64.la cencode.lo cdecode.lo ${LDFLAGS} -rpath "/usr/$(get_libdir)" -version-info 0:2:0 || die
	cd - &>/dev/null
}

src_install() {
	dolib.so src/.libs/libb64.so*
	if use static-libs; then
		dolib.a src/.libs/libb64.a
	fi
	insinto /usr/include
	doins -r include/b64
	einstalldocs
}
