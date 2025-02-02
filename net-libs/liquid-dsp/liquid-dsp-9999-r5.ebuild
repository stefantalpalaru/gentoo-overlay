# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic git-r3 multilib-minimal

DESCRIPTION="digital signal processing library for software-defined radios"
HOMEPAGE="http://liquidsdr.org/"
EGIT_REPO_URI="https://github.com/jgaeddert/liquid-dsp.git"
LICENSE="MIT-with-advertising"
SLOT="0"

DEPEND="sci-libs/fftw:3.0"
RDEPEND="${DEPEND}"

src_prepare() {
	cmake_src_prepare
	append-flags -ffast-math
	multilib_copy_sources
}

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLES=OFF
		-DBUILD_AUTOTESTS=OFF
		-DBUILD_BENCHMARKS=OFF
	)
	cmake_src_configure
}

multilib_src_compile() {
	cmake_src_compile
}

multilib_src_install() {
	cmake_src_install
}
