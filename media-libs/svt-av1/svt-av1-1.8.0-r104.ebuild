# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib flag-o-matic

DESCRIPTION="Scalable Video Technology for AV1 (SVT-AV1 Encoder and Decoder)"
HOMEPAGE="https://gitlab.com/AOMediaCodec/SVT-AV1"
SRC_URI="https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v${PV}/SVT-AV1-v${PV}.tar.bz2 -> ${P}.tar.bz2
		pgo? ( https://media.xiph.org/video/derf/y4m/stefan_sif.y4m )"
S="${WORKDIR}/SVT-AV1-v${PV}"

# Also see "Alliance for Open Media Patent License 1.0"
LICENSE="BSD-2 Apache-2.0 BSD ISC LGPL-2.1+ MIT"
SLOT="0/1"
KEYWORDS="~amd64 ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="+lto +pgo cpu_flags_x86_avx512f"

BDEPEND="
	amd64? ( dev-lang/yasm )
"

PATCHES=(
	"${FILESDIR}"/svt-av1-1.5.0-fortify-no-override.patch
	"${FILESDIR}"/svt-av1-1.8.0-PGO.patch
)

src_unpack() {
	for F in ${A}; do
		case "${F}" in
			*.y4m)
				cp -a "${DISTDIR}/${F}" . || die
				;;
			*)
				unpack "${F}"
				;;
		esac
	done

	if use pgo; then
		mkdir pgo_videos
		mv *.y4m pgo_videos/
	fi
}

multilib_src_configure() {
	append-ldflags -Wl,-z,noexecstack

	local mycmakeargs=(
		-DCMAKE_VERBOSE_MAKEFILE=ON
		# Tests require linking against https://github.com/Cidana-Developers/aom/tree/av1-normative
		# undefined reference to `ifd_inspect'
		# https://github.com/Cidana-Developers/aom/commit/cfc5c9e95bcb48a5a41ca7908b44df34ea1313c0
		# .. and https://gitlab.com/AOMediaCodec/SVT-AV1/-/blob/master/.gitlab/workflows/linux/.gitlab-ci.yml implies it's all quite manual
		-DBUILD_TESTING=OFF
		-DSVT_AV1_LTO=$(usex lto)
		-DSVT_AV1_PGO=$(usex pgo)
		-DSVT_AV1_PGO_CUSTOM_VIDEOS="${WORKDIR}/pgo_videos"
		-DCMAKE_OUTPUT_DIRECTORY="${BUILD_DIR}"
		-DENABLE_AVX512=$(usex cpu_flags_x86_avx512f)
		-DEXCLUDE_HASH=ON
	)

	cmake_src_configure
}

multilib_src_compile() {
	if use pgo; then
		cmake_src_compile RunPGO
	else
		cmake_src_compile
	fi
}
