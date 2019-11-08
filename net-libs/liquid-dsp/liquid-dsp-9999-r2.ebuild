# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic git-r3 multilib-minimal

DESCRIPTION="digital signal processing library for software-defined radios"
HOMEPAGE="http://liquidsdr.org/"
EGIT_REPO_URI="https://github.com/jgaeddert/liquid-dsp.git"

LICENSE="MIT-with-advertising"
SLOT="0"
KEYWORDS=""
IUSE="static-libs"

DEPEND="sci-libs/fftw:3.0"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-libdir-r1.patch" )

src_prepare() {
	default
	append-flags -ffast-math
	eautoreconf
	multilib_copy_sources
}

multilib_src_install_all() {
	default
	use static-libs || rm "${ED}"/usr/"$(get_libdir)"/libliquid.a
}
