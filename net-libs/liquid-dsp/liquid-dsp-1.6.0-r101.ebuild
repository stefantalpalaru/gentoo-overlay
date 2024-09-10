# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic multilib-minimal

DESCRIPTION="digital signal processing library for software-defined radios"
HOMEPAGE="http://liquidsdr.org/"
SRC_URI="https://github.com/jgaeddert/liquid-dsp/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT-with-advertising"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND="sci-libs/fftw:3.0"
RDEPEND="${DEPEND}"

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
