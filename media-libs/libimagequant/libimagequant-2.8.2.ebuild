# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Palette quantization library that powers pngquant and other PNG optimizers"
HOMEPAGE="https://pngquant.org/lib/"
SRC_URI="https://github.com/ImageOptim/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE="cpu_flags_x86_sse2 debug openmp static-libs"

DEPEND=""
RDEPEND="${DEPEND}"

src_configure() {
	tc-export AR CC
	# Hand rolled configure script, so not all flags are supported.
	./configure \
		--prefix="${EPREFIX}/usr" \
		$(use debug && echo --enable-debug) \
		$(use_enable cpu_flags_x86_sse2 sse) \
		$(use openmp && tc-has-openmp && echo --with-openmp) \
		CFLAGS="${CFLAGS} ${CPPFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_compile() {
	emake shared || die "make failed"
	use static-libs && (emake static || die "make failed")
}

src_install() {
	dolib.so libimagequant.so
	dolib.so libimagequant.so.*
	use static-libs && dolib.a libimagequant.a
	doheader libimagequant.h
	einstalldocs
}
