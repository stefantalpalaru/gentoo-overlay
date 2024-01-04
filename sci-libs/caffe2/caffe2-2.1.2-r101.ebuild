# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10,11} )
inherit git-r3 cmake cuda flag-o-matic python-single-r1

MYPN=pytorch

DESCRIPTION="A deep learning framework"
HOMEPAGE="https://pytorch.org/"
# We need the complete archive, with all thirdparty modules, for the "cutlass" library (used when CUDA is enabled)
#SRC_URI="https://github.com/pytorch/pytorch/releases/download/v${PV}/pytorch-v${PV}.tar.gz
	#-> ${MYPN}-full-${PV}.tar.gz"

# It takes weeks for a full source tarball to appear attached to a release. Use Git instead.
EGIT_REPO_URI="https://github.com/pytorch/pytorch"
EGIT_COMMIT="v${PV}"
EGIT_SUBMODULES=(
	'*'
	'-third_party/pybind11'
	'-third_party/NNPACK_deps/FP16'
	'-third_party/NNPACK_deps/FXdiv'
	'-third_party/NNPACK_deps/psimd'
	'-third_party/NNPACK_deps/pthreadpool'
	'-android/libs/fbjni'
	'-third_party/FP16'
	'-third_party/FXdiv'
	'-third_party/NNPACK'
	'-third_party/QNNPACK'
	'-third_party/VulkanMemoryAllocator'
	'-third_party/XNNPACK'
	'-third_party/benchmark'
	'-third_party/cpuinfo'
	'-third_party/cub'
	'-third_party/cudnn_frontend'
	'-third_party/eigen'
	'-third_party/fbgemm'
	'-third_party/flatbuffers'
	'-third_party/fmt'
	'-third_party/foxi'
	'-third_party/gemmlowp/gemmlowp'
	'-third_party/gloo'
	'-third_party/googletest'
	'-third_party/ideep'
	'-third_party/ios-cmake'
	'-third_party/ittapi'
	'-third_party/mimalloc'
	'-third_party/nccl/nccl'
	'-third_party/neon2sse'
	'-third_party/nlohmann'
	'-third_party/pocketfft'
	'-third_party/protobuf'
	'-third_party/psimd'
	'-third_party/pthreadpool'
	'-third_party/python-enum'
	'-third_party/python-peachpy'
	'-third_party/python-six'
	'-third_party/sleef'
	'-third_party/tbb'
	'-third_party/zstd'
)

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cuda distributed ffmpeg nnpack mpi +numpy opencl opencv openmp qnnpack xnnpack"
RESTRICT="test"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	ffmpeg? ( opencv )
	mpi? ( distributed )
" # ?? ( cuda rocm )

RDEPEND="
	${PYTHON_DEPS}
	dev-cpp/gflags:=
	>=dev-cpp/glog-0.5.0
	dev-libs/cpuinfo
	dev-libs/libfmt
	dev-libs/protobuf:=
	dev-libs/pthreadpool
	dev-libs/sleef
	sci-libs/lapack
	sci-libs/foxi
	cuda? (
		dev-libs/cudnn:0/8
		dev-libs/cudnn-frontend:0/8
		=dev-util/nvidia-cuda-toolkit-12*:=[profiler]
	)
	ffmpeg? ( media-video/ffmpeg:= )
	mpi? ( sys-cluster/openmpi )
	nnpack? ( sci-libs/NNPACK )
	numpy? ( $(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		') )
	opencl? ( virtual/opencl )
	opencv? ( media-libs/opencv:= )
	qnnpack? ( sci-libs/QNNPACK )
	xnnpack? ( sci-libs/XNNPACK )
"
# Torch uses recent Kineto commits that have not been released, then installs the library headers.
DEPEND="
	${RDEPEND}
	dev-cpp/eigen
	dev-libs/psimd
	dev-libs/FP16
	dev-libs/FXdiv
	dev-libs/pocketfft
	dev-libs/flatbuffers
	$(python_gen_cond_dep '
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/pybind11[${PYTHON_USEDEP}]
	')
	!!sci-libs/kineto
"
BDEPEND="${DEPEND}"

#S="${WORKDIR}"/${MYPN}-v${PV}

PATCHES=(
	"${FILESDIR}"/${PN}-2.1.0-gentoo.patch
	"${FILESDIR}"/${PN}-1.13.0-install-dirs.patch
	"${FILESDIR}"/${PN}-1.12.0-glog-0.6.0.patch
	"${FILESDIR}"/caffe2-1.13.1-functorch.patch
	"${FILESDIR}"/caffe2-2.1.0-nvfuser.patch
)

src_prepare() {
	filter-lto #bug 862672
	rm -rf third_party/flatbuffers # wrong FLATBUFFERS_VERSION_MAJOR (2 instead of 23)
	cmake_src_prepare
	pushd torch/csrc/jit/serialization || die
	flatc --cpp --gen-mutable --scoped-enums mobile_bytecode.fbs || die
	popd
}

src_configure() {
	if use cuda && [[ -z ${TORCH_CUDA_ARCH_LIST} ]]; then
		ewarn "WARNING: caffe2 is being built with its default CUDA compute capabilities: 3.5 and 7.0."
		ewarn "These may not be optimal for your GPU."
		ewarn ""
		ewarn "To configure caffe2 with the CUDA compute capability that is optimal for your GPU,"
		ewarn "set TORCH_CUDA_ARCH_LIST in your make.conf, and re-emerge caffe2."
		ewarn "For example, to use CUDA capability 7.5 & 3.5, add: TORCH_CUDA_ARCH_LIST=7.5,3.5"
		ewarn "For a Maxwell model GPU, an example value would be: TORCH_CUDA_ARCH_LIST=Maxwell"
		ewarn ""
		ewarn "You can look up your GPU's CUDA compute capability at https://developer.nvidia.com/cuda-gpus"
		ewarn "or by running /opt/cuda/extras/demo_suite/deviceQuery | grep 'CUDA Capability'"
	fi

	local mycmakeargs=(
		-DBUILD_CUSTOM_PROTOBUF=OFF
		-DBUILD_SHARED_LIBS=ON

		-DUSE_CCACHE=OFF
		-DUSE_CUDA=$(usex cuda)
		-DUSE_CUDNN=$(usex cuda)
		-DTORCH_CUDA_ARCH_LIST="${TORCH_CUDA_ARCH_LIST:-3.5 7.0}"
		-DUSE_DISTRIBUTED=$(usex distributed)
		-DUSE_TENSORPIPE=$(usex distributed) # required by USE_DISTRIBUTED
		-DUSE_MPI=$(usex mpi)
		-DUSE_UCC=OFF
		-DUSE_FAKELOWP=OFF
		-DUSE_FBGEMM=OFF # TODO
		-DUSE_FFMPEG=$(usex ffmpeg)
		-DUSE_GFLAGS=ON
		-DUSE_GLOG=ON
		-DUSE_GLOO=OFF
		-DUSE_KINETO=ON
		-DUSE_LEVELDB=OFF
		-DUSE_MAGMA=OFF # TODO: In GURU as sci-libs/magma
		-DUSE_MKLDNN=OFF
		-DUSE_NCCL=OFF # TODO: NVIDIA Collective Communication Library
		-DUSE_NNPACK=$(usex nnpack)
		-DUSE_QNNPACK=$(usex qnnpack)
		-DUSE_XNNPACK=$(usex xnnpack)
		-DUSE_SYSTEM_XNNPACK=$(usex xnnpack)
		-DUSE_PYTORCH_QNNPACK=OFF
		-DUSE_NUMPY=$(usex numpy)
		-DUSE_OPENCL=$(usex opencl)
		-DUSE_OPENCV=$(usex opencv)
		-DUSE_OPENMP=$(usex openmp)
		-DUSE_ROCM=OFF # TODO
		-DUSE_SYSTEM_CPUINFO=ON
		-DUSE_SYSTEM_PYBIND11=ON
		-DUSE_VALGRIND=OFF
		-DPYBIND11_PYTHON_VERSION="${EPYTHON#python}"
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DUSE_ITT=OFF
		-DBLAS=Eigen # avoid the use of MKL, if found on the system
		-DUSE_SYSTEM_EIGEN_INSTALL=ON
		-DUSE_SYSTEM_PTHREADPOOL=ON
		-DUSE_SYSTEM_FXDIV=ON
		-DUSE_SYSTEM_FP16=ON
		-DUSE_SYSTEM_GLOO=ON
		-DUSE_SYSTEM_ONNX=OFF
		-DUSE_SYSTEM_SLEEF=ON

		-Wno-dev
		-DTORCH_INSTALL_LIB_DIR="${EPREFIX}"/usr/$(get_libdir)
		-DLIBSHM_INSTALL_LIB_SUBDIR="${EPREFIX}"/usr/$(get_libdir)
	)

	if use cuda; then
		addpredict "/dev/nvidiactl" # bug 867706

		mycmakeargs+=(
			-DCMAKE_CUDA_FLAGS="$(cuda_gccdir -f | tr -d \")"
		)
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install

	insinto "/var/lib/${PN}"
	doins "${BUILD_DIR}"/CMakeCache.txt

	mkdir -p python/torch/include || die
	mv "${ED}"/usr/lib/python*/site-packages/caffe2 python/ || die
	mv "${ED}"/usr/include/torch python/torch/include || die
	cp torch/version.py python/torch/ || die
	python_domodule python/caffe2
	python_domodule python/torch

	rm "${ED}/usr/$(get_libdir)/__init__.py" || die
}
