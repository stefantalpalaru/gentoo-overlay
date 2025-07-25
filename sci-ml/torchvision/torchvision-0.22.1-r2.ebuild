# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1

inherit cuda cuda-extra distutils-r1 multiprocessing

DESCRIPTION="Datasets, transforms and models to specific to computer vision"
HOMEPAGE="https://github.com/pytorch/vision"
SRC_URI="https://github.com/pytorch/vision/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/vision-${PV}"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cuda +ffmpeg +jpeg +png rocm +webp"
RESTRICT="test? ( network-sandbox )"

RDEPEND="
	dev-python/numpy
	dev-python/pillow
	jpeg? ( media-libs/libjpeg-turbo:= )
	png? ( media-libs/libpng:= )
	webp? ( media-libs/libwebp )
	ffmpeg? ( media-video/ffmpeg )
	sci-ml/caffe2[cuda?,rocm?]
	sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		$(python_gen_cond_dep '
			dev-python/pytest-mock[${PYTHON_USEDEP}]
			dev-python/lmdb[${PYTHON_USEDEP}]
		')
	)
"

distutils_enable_tests pytest

src_prepare() {
	# multilib fixes
	sed "s/ffmpeg_root, \"lib\"/ffmpeg_root, \"$(get_libdir)\"/" \
		-i setup.py || die

	export MAX_JOBS="$(makeopts_jobs)"
	export MAKEOPTS=-j1
	addpredict /dev/kfd

	if use cuda; then
		export NVCC_FLAGS="$(cuda_gccdir -f | tr -d \")"
		addpredict "/proc/self/task" # bug 926116
	fi

	if use cuda || use rocm; then
	  export FORCE_CUDA=1
	fi

	export TORCHVISION_USE_PNG=$(usex png 1 0)
	export TORCHVISION_USE_JPEG=$(usex jpeg 1 0)
	export TORCHVISION_USE_WEBP=$(usex webp 1 0)
	export TORCHVISION_USE_FFMPEG=$(usex ffmpeg 1 0)

	export TORCHVISION_USE_NVJPEG=$(usex cuda 1 0)
	export TORCHVISION_USE_VIDEO_CODEC=$(usex cuda 1 0)

	use cuda && cuda_src_prepare
	distutils-r1_src_prepare
}

python_test() {
	if use cuda; then
		cuda_add_sandbox -w
		addwrite "/proc/self/task"
		addpredict "/dev/char/"
		cuda_check_permissions || die "Cannot access CUDA device. Aborting."
	fi

	rm -rf torchvision || die

	local EPYTEST_IGNORE=(
		test/test_videoapi.py
	)
	local EPYTEST_DESELECT=(
		test/test_backbone_utils.py::TestFxFeatureExtraction::test_forward_backward
		test/test_backbone_utils.py::TestFxFeatureExtraction::test_jit_forward_backward
		test/test_models.py::test_classification_model
		test/test_extended_models.py::TestHandleLegacyInterface::test_pretrained_pos
		test/test_extended_models.py::TestHandleLegacyInterface::test_equivalent_behavior_weights
		test/test_image.py::test_decode_avif[decode_avif]
		test/test_image.py::test_decode_bad_encoded_data
		test/test_image.py::test_decode_gif[True-earth]
		test/test_image.py::test_decode_heic[decode_heic]
		test/test_image.py::test_decode_webp
		test/test_models.py::test_quantized_classification_model
		test/test_ops.py::test_roi_opcheck
		test/test_ops.py::TestDeformConv::test_aot_dispatch_dynamic__test_backward
		test/test_ops.py::TestDeformConv::test_aot_dispatch_dynamic__test_forward
	)
	epytest
}
