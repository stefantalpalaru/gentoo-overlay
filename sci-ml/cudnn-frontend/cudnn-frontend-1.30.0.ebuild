# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_EXT=1
DISTUTILS_OPTIONAL=1

inherit distutils-r1 cmake cuda cuda-extra

DESCRIPTION="A c++ wrapper for the cudnn backend API"
HOMEPAGE="https://github.com/NVIDIA/cudnn-frontend"
SRC_URI="https://github.com/NVIDIA/cudnn-frontend/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0 MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64"
IUSE="python test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-cpp/nlohmann_json
	>=dev-libs/cudnn-9:0=
	>=dev-libs/cutlass-4.6.2:=
	python? (
		$(python_gen_cond_dep '
			>=dev-python/apache-tvm-ffi-0.1.10:=[${PYTHON_USEDEP}]
			dev-python/pybind11[${PYTHON_USEDEP}]
		')
		sci-libs/dlpack
		test? (
			$(python_gen_cond_dep '
				dev-python/looseversion[${PYTHON_USEDEP}]
			')
		)
	)
	>=dev-util/nvidia-cuda-toolkit-13:=
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/cudnn-frontend-1.29.0-includes.patch
	"${FILESDIR}"/cudnn-frontend-1.29.0-dlpack.patch
	"${FILESDIR}"/cudnn-frontend-1.29.0-setup.py.patch
)

distutils_enable_tests pytest

src_prepare() {
	cmake_src_prepare
	cuda_src_prepare_extra

	PATCHES=() # Already applied.
	distutils-r1_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCUDA_TOOLKIT_ROOT_DIR="${EPREFIX}/opt/cuda"
		-DCMAKE_CUDA_COMPILER="nvcc"
		-DCMAKE_CUDA_HOST_COMPILER="$(cuda_gcc)"
		-DCMAKE_CUDA_FLAGS="-forward-unknown-opts -fno-lto ${NVCCFLAGS//\"/\'}"
		-DCUDNN_FRONTEND_BUILD_SAMPLES=OFF
		-DCUDNN_FRONTEND_BUILD_TESTS=$(usex test)
		-DCUDNN_FRONTEND_BUILD_PYTHON_BINDINGS=$(usex python)
		-DCUDNN_FRONTEND_USE_SYSTEM_DLPACK=ON
		-DCUDNN_FRONTEND_FETCH_PYBINDS_IN_CMAKE=OFF
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	distutils-r1_src_compile
}

src_test() {
	"${BUILD_DIR}"/bin/tests || die
	distutils-r1_src_test
}

src_install() {
	if use amd64; then
		narch=x86_64
	elif use arm64; then
		narch=sbsa
	else
		die "unknown arch ${ARCH}"
	fi

	insinto /opt/cuda/targets/${narch}-linux
	doins -r include

	if use python; then
		distutils-r1_src_install
	fi
}
