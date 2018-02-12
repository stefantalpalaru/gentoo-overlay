# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-multilib

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://aomedia.googlesource.com/aom"
elif [[ ${PV} == *pre* ]]; then
	SRC_URI="mirror://gentoo/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
fi

DESCRIPTION="Alliance for Open Media AV1 Codec SDK"
HOMEPAGE="http://aomedia.org"

LICENSE="BSD-2"
SLOT="0/4"
IUSE="cpu_flags_arm_neon cpu_flags_x86_avx cpu_flags_x86_avx2 doc cpu_flags_x86_mmx cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse3 cpu_flags_x86_ssse3 cpu_flags_x86_sse4_1 mipsdspr2 mipsmsa"

RDEPEND="abi_x86_32? ( !app-emulation/emul-linux-x86-medialibs[-abi_x86_32(-)] )"
DEPEND="abi_x86_32? ( dev-lang/yasm )
	abi_x86_64? ( dev-lang/yasm )
	abi_x86_x32? ( dev-lang/yasm )
	x86-fbsd? ( dev-lang/yasm )
	amd64-fbsd? ( dev-lang/yasm )
	doc? (
		app-doc/doxygen
		dev-lang/php
	)
"

REQUIRED_USE="
	cpu_flags_x86_sse2? ( cpu_flags_x86_mmx )
	cpu_flags_x86_ssse3? ( cpu_flags_x86_sse2 )
"

src_prepare() {
	default

	sed -i -e "s/DESTINATION \"\${CMAKE_INSTALL_PREFIX}\/lib/DESTINATION \"\${CMAKE_INSTALL_PREFIX}\/\${CMAKE_INSTALL_LIBDIR}/" \
		CMakeLists.txt

	cmake-utils_src_prepare
}

multilib_src_configure() {
	echo $(get_libdir)
	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR=$(get_libdir)
		-DENABLE_TOOLS=OFF
		-DENABLE_NEON=$(usex cpu_flags_arm_neon ON OFF)
		-DENABLE_NEON_ASM=$(usex cpu_flags_arm_neon ON OFF)
		-DENABLE_DSPR2=$(usex mipsdspr2 ON OFF)
		-DENABLE_MSA=$(usex mipsmsa ON OFF)
		-DENABLE_MMX=$(usex cpu_flags_x86_mmx ON OFF)
		-DENABLE_SSE=$(usex cpu_flags_x86_sse ON OFF)
		-DENABLE_SSE2=$(usex cpu_flags_x86_sse2 ON OFF)
		-DENABLE_SSE3=$(usex cpu_flags_x86_sse3 ON OFF)
		-DENABLE_SSSE3=$(usex cpu_flags_x86_ssse3 ON OFF)
		-DENABLE_SSE4_1=$(usex cpu_flags_x86_sse4_1 ON OFF)
		-DENABLE_AVX=$(usex cpu_flags_x86_avx ON OFF)
		-DENABLE_AVX2=$(usex cpu_flags_x86_avx2 ON OFF)
		-DBUILD_SHARED_LIBS=ON
		-DENABLE_EXAMPLES=OFF
		-DENABLE_DOCS=$(usex doc ON OFF)
		-DCONFIG_ANALYZER=0
		-DCONFIG_UNIT_TESTS=0
	)
	cmake-utils_src_configure
}

multilib_src_install() {
	cmake-utils_src_install

	[ "${ABI}" = "${DEFAULT_ABI}" ] && use doc && dodoc -r docs/html
}
