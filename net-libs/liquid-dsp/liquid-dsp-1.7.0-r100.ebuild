# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic multilib-minimal

DESCRIPTION="digital signal processing library for software-defined radios"
HOMEPAGE="http://liquidsdr.org/"
SRC_URI="https://github.com/jgaeddert/liquid-dsp/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT-with-advertising"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sci-libs/fftw:3.0"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/liquid-dsp-1.7.0-CMake-fix-x86-SIMD-detection.patch"
)

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
