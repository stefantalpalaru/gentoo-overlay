# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib flag-o-matic

DESCRIPTION="Scalable Video Technology for AV1 (SVT-AV1 Encoder and Decoder)"
HOMEPAGE="https://gitlab.com/AOMediaCodec/SVT-AV1"
SRC_URI="https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v${PV}/SVT-AV1-v${PV}.tar.bz2 -> ${P}.tar.bz2"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv sparc x86"

# Also see "Alliance for Open Media Patent License 1.0"
LICENSE="BSD-2 Apache-2.0 BSD ISC LGPL-2.1+ MIT"
SLOT="0"
IUSE="lto pgo"

BDEPEND="amd64? ( dev-lang/yasm )"
RESTRICT="pgo? ( network-sandbox )"

S="${WORKDIR}/SVT-AV1-v${PV}"

src_prepare() {
	default

	# https://gitlab.com/AOMediaCodec/SVT-AV1/-/issues/2015
	sed -i \
		-e 's/CMAKE_VERSION GREATER_EQUAL/CMAKE_VERSION VERSION_GREATER_EQUAL/' \
		CMakeLists.txt || die

	cmake_src_prepare
}

multilib_src_configure() {
	append-ldflags -Wl,-z,noexecstack

	local mycmakeargs=(
		# Tests require linking against https://github.com/Cidana-Developers/aom/tree/av1-normative ?
		# undefined reference to `ifd_inspect'
		# https://github.com/Cidana-Developers/aom/commit/cfc5c9e95bcb48a5a41ca7908b44df34ea1313c0
		-DBUILD_TESTING=OFF
		-DSVT_AV1_LTO=$(usex lto)
		-DSVT_AV1_PGO=$(usex pgo)
		-DCMAKE_OUTPUT_DIRECTORY="${BUILD_DIR}"
	)

	[[ ${ABI} != amd64 ]] && mycmakeargs+=( -DCOMPILE_C_ONLY=ON )

	cmake_src_configure
}