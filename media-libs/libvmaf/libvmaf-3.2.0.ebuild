# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cuda cuda-extra meson-multilib flag-o-matic

DESCRIPTION="C library for Netflix's Perceptual video quality assessment"
HOMEPAGE="https://github.com/Netflix/vmaf"
SRC_URI="https://github.com/Netflix/vmaf/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/vmaf-${PV}"
LICENSE="BSD-2-with-patent"
SLOT="0/3"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
IUSE="+embed-models cuda lto test"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-lang/nasm
	embed-models? ( dev-util/xxd )
"

RDEPEND="${BDEPEND}
	cuda? (
		dev-util/nvidia-cuda-toolkit:=
	)
"

PATCHES=(
	"${FILESDIR}"/libvmaf-3.2.0-cuda.patch
)

src_prepare() {
	default
}

multilib_src_prepare() {
	if use cuda; then
		cuda_src_prepare_extra
	fi
}

multilib_src_configure() {
	local emesonargs=(
		$(meson_use embed-models built_in_models)
		$(meson_use test enable_tests)
		$(meson_use lto b_lto)
		-Denable_float=true
	)

	if use cuda && multilib_is_native_abi; then
		emesonargs+=(
			-Denable_cuda=true
			-Denable_nvcc=true
			-Dcuda_ccbindir="$(cuda_gcc | sed 's/gcc/g++/')"
		)
	fi

	EMESON_SOURCE="${S}/libvmaf"
	filter-lto
	meson_src_configure
}

# We don't need CUDA-specific headers in the x86 build.
multilib_check_headers() {
	:
}

multilib_src_install() {
	meson_src_install
	find "${D}" -name '*.la' -delete -o -name '*.a' -delete || die
}

multilib_src_test() {
	cuda_add_sandbox -w
	cuda_check_permissions

	meson_src_test
}

multilib_src_install_all() {
	einstalldocs

	insinto "/usr/share/vmaf"
	doins -r "${S}/model"
}
