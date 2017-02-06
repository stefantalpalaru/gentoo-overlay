# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools flag-o-matic git-r3 multilib-minimal

DESCRIPTION="digital signal processing library for software-defined radios"
HOMEPAGE="http://liquidsdr.org/"
EGIT_REPO_URI="https://github.com/jgaeddert/liquid-dsp.git"
EGIT_COMMIT="7c53e1311798d4c7660abe24df37bc2d22c770cc"

LICENSE="MIT-with-advertising"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND="sci-libs/fftw:3.0"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-9999-libdir.patch" )

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
