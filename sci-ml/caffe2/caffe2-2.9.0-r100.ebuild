# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..14} )
ROCM_VERSION=6.1
MYPN=pytorch
MYP=${MYPN}-${PV}
# caffe2-2.6.0 depends on future version of composable kernel
# TODO: replace it with RDEPEND in the future
CK_COMMIT=8086bbe3a78d931eb96fe12fdc014082e18d18d3
CK_P=composable_kernel-${CK_COMMIT:0:8}

inherit python-single-r1 cmake cuda flag-o-matic prefix rocm toolchain-funcs

DESCRIPTION="A deep learning framework"
HOMEPAGE="https://pytorch.org/"
SRC_URI="https://github.com/pytorch/pytorch/releases/download/v${PV}/pytorch-v${PV}.tar.gz
	-> ${MYP}-full.tar.gz
	rocm? (
		https://github.com/ROCm/composable_kernel/archive/${CK_COMMIT}.tar.gz
		-> ${CK_P}.tar.gz
	)
"
S="${WORKDIR}"/pytorch-v${PV}
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="cuda cudss distributed fbgemm flash gloo memefficient mkl mpi nnpack +numpy onednn openblas opencl openmp qnnpack rocm vulkan xnnpack cpu_flags_x86_avx cpu_flags_x86_avx2 cpu_flags_x86_avx512f"
RESTRICT="test"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	fbgemm? ( cpu_flags_x86_avx cpu_flags_x86_avx2 cpu_flags_x86_avx512f )
	flash? ( || ( cuda rocm ) )
	memefficient? ( || ( cuda rocm ) )
	mpi? ( distributed )
	gloo? ( distributed )
	?? ( cuda rocm )
	rocm? (
		|| ( ${ROCM_REQUIRED_USE} )
		!flash
	)
"

RDEPEND="
	${PYTHON_DEPS}
	dev-cpp/abseil-cpp:=
	dev-cpp/gflags:=
	>=dev-cpp/glog-0.5.0
	dev-cpp/nlohmann_json
	dev-cpp/opentelemetry-cpp
	dev-libs/cpuinfo
	dev-libs/libfmt:=
	dev-libs/protobuf:=
	dev-libs/pthreadpool
	dev-libs/sleef
	sci-ml/foxi
	sci-ml/onnx:=
	virtual/lapack
	cuda? (
		dev-libs/cudnn:=
		>=sci-ml/cudnn-frontend-1.0.3:0=
		cudss? ( dev-libs/cudss )
		dev-libs/cusparselt
		>=dev-util/nvidia-cuda-toolkit-12.9:=[profiler]
	)
	fbgemm? ( sci-ml/FBGEMM )
	gloo? ( >=sci-ml/gloo-2025.06.04[cuda?] )
	mpi? ( virtual/mpi )
	nnpack? ( sci-ml/NNPACK )
	numpy? ( $(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		') )
	onednn? ( sci-ml/oneDNN )
	opencl? ( virtual/opencl )
	qnnpack? (
		sci-ml/gemmlowp
	)
	rocm? (
		>=dev-libs/rccl-6.1      <dev-libs/rccl-6.5
		>=dev-util/hip-6.1       <dev-util/hip-6.5
		>=dev-util/roctracer-6.1 <dev-util/roctracer-6.5
		>=sci-libs/hipBLAS-6.1   <sci-libs/hipBLAS-6.5
		>=sci-libs/hipBLASLt-6.1 <sci-libs/hipBLASLt-6.5
		>=sci-libs/hipCUB-6.1    <sci-libs/hipCUB-6.5
		>=sci-libs/hipFFT-6.1    <sci-libs/hipFFT-6.5
		>=sci-libs/hipRAND-6.1   <sci-libs/hipRAND-6.5
		>=sci-libs/hipSOLVER-6.1 <sci-libs/hipSOLVER-6.5
		>=sci-libs/hipSPARSE-6.1 <sci-libs/hipSPARSE-6.5
		>=sci-libs/miopen-6.1    <sci-libs/miopen-6.5
		>=sci-libs/rocPRIM-6.1   <sci-libs/rocPRIM-6.5
		>=sci-libs/rocThrust-6.1 <sci-libs/rocThrust-6.5
		memefficient? ( sci-libs/aotriton-bin:0/0.9 )
	)
	distributed? (
		sci-ml/tensorpipe[cuda?]
		dev-cpp/cpp-httplib
	)
	xnnpack? ( >=sci-ml/XNNPACK-2024.11 )
	mkl? ( sci-libs/mkl )
	openblas? ( sci-libs/openblas )
	vulkan? ( media-libs/vulkan-loader )
"
DEPEND="
	${RDEPEND}
	dev-libs/flatbuffers
	dev-libs/FXdiv
	dev-libs/pocketfft
	dev-libs/psimd
	sci-ml/FP16
	$(python_gen_cond_dep '
		dev-python/pybind11[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	')
	cuda? ( >=dev-libs/cutlass-3.8.0 )
	onednn? ( sci-ml/ideep )
	qnnpack? ( dev-libs/clog )
"

PATCHES=(
	"${FILESDIR}"/caffe2-2.9.0-gentoo-r1.patch
	"${FILESDIR}"/caffe2-2.6.0-install-dirs.patch
	"${FILESDIR}"/caffe2-1.12.0-glog-0.6.0.patch
	"${FILESDIR}"/caffe2-2.9.0-tensorpipe.patch
	"${FILESDIR}"/caffe2-2.3.0-cudnn_include_fix.patch
	"${FILESDIR}"/caffe2-2.1.2-fix-rpath.patch
	"${FILESDIR}"/caffe2-2.4.0-fix-openmp-link.patch
	"${FILESDIR}"/caffe2-2.4.0-rocm-fix-std-cpp17.patch
	"${FILESDIR}"/caffe2-2.4.0-cpp-httplib.patch
	"${FILESDIR}"/caffe2-2.5.1-newfix-functorch-install.patch
	"${FILESDIR}"/caffe2-2.7.0-glog-0.7.1.patch
	"${FILESDIR}"/caffe2-2.7.1-aotriton-fixes.patch
	"${FILESDIR}"/caffe2-2.8.0-kineto.patch
	"${FILESDIR}"/caffe2-2.9.0-CUDA-13.patch
	"${FILESDIR}"/caffe2-2.9.0-fbgemm.patch
)

src_prepare() {
	filter-lto #bug 862672

	sed -i \
		-e "/third_party\/gloo/d" \
		cmake/Dependencies.cmake \
		|| die

	# Change libaotriton path
	sed -i \
		-e "s|}/lib|}/$(get_libdir)|g" \
		cmake/External/aotriton.cmake \
		|| die

	# Noisy warnings from Logging.h
	sed -i 's/-Wextra-semi//' cmake/public/utils.cmake || die

	cmake_src_prepare
	pushd torch/csrc/jit/serialization || die
	flatc --cpp --gen-mutable --scoped-enums mobile_bytecode.fbs || die
	popd

	# prefixify the hardcoded paths, after all patches are applied
	hprefixify \
		aten/CMakeLists.txt \
		caffe2/CMakeLists.txt \
		cmake/Metal.cmake \
		cmake/Modules/*.cmake \
		cmake/Modules_CUDA_fix/FindCUDNN.cmake \
		cmake/Modules_CUDA_fix/upstream/FindCUDA/make2cmake.cmake \
		cmake/Modules_CUDA_fix/upstream/FindPackageHandleStandardArgs.cmake \
		cmake/public/LoadHIP.cmake \
		cmake/public/cuda.cmake \
		cmake/Dependencies.cmake \
		torch/CMakeLists.txt \
		CMakeLists.txt

	if use rocm; then
		sed -e "s:/opt/rocm:/usr:" \
			-e "s:lib/cmake:$(get_libdir)/cmake:g" \
			-i cmake/public/LoadHIP.cmake || die

		# TODO: delete, when caffe2 depends on systemwide composable_kernel
		sed -e "s:third_party/composable_kernel:../composable_kernel-${CK_COMMIT}:g" \
			-i aten/src/ATen/CMakeLists.txt || die

		# Bug 959808: fix for gfx101x targets
		pushd "${WORKDIR}/composable_kernel-${CK_COMMIT}" > /dev/null || die
		eapply "${FILESDIR}"/composable-kernel-6.4.1-expand-isa.patch
		popd > /dev/null || die

		if tc-is-clang; then
			# Systemwide gcc (for absl and at::TensorBase) + hipcc (llvm>=18) need abi-compat=17.
			# But systemwide clang>=18 + hipcc (>=llvm-18) need opposite!
			# See also: https://github.com/llvm/llvm-project/issues/102443#issuecomment-2329726287
			sed '/-fclang-abi-compat=17/d' -i cmake/Dependencies.cmake || die
		fi

		# Workaround for libc++ issue https://github.com/llvm/llvm-project/issues/100802
		sed 's/std::memcpy/memcpy/g' -i c10/util/Half.h || die

		ebegin "HIPifying cuda sources"
		${EPYTHON} tools/amd_build/build_amd.py || die
		eend $?
	fi

	rm -rf third_party/flatbuffers
}

src_configure() {
	if use cuda && [[ -z ${TORCH_CUDA_ARCH_LIST} ]]; then
		ewarn "WARNING: caffe2 is being built with its default CUDA compute capabilities: 5.0 and 7.0."
		ewarn "These may not be optimal for your GPU."
		ewarn ""
		ewarn "To configure caffe2 with the CUDA compute capability that is optimal for your GPU,"
		ewarn "set TORCH_CUDA_ARCH_LIST in your make.conf, and re-emerge caffe2."
		ewarn "For example, to use CUDA capability 7.5, add: TORCH_CUDA_ARCH_LIST=7.5"
		ewarn "For a Maxwell model GPU, an example value would be: TORCH_CUDA_ARCH_LIST=Maxwell"
		ewarn ""
		ewarn "You can look up your GPU's CUDA compute capability at https://developer.nvidia.com/cuda-gpus"
		ewarn "or by running /opt/cuda/extras/demo_suite/deviceQuery | grep 'CUDA Capability'"
	fi

	local mycmakeargs=(
		-DBUILD_CUSTOM_PROTOBUF=OFF
		-DBUILD_SHARED_LIBS=ON
		-DLIBSHM_INSTALL_LIB_SUBDIR="${EPREFIX}"/usr/$(get_libdir)
		-DPython_EXECUTABLE="${PYTHON}"
		-DTORCH_INSTALL_LIB_DIR="${EPREFIX}"/usr/$(get_libdir)
		-DUSE_CCACHE=OFF
		-DUSE_CUDA=$(usex cuda)
		-DUSE_DISTRIBUTED=$(usex distributed)
		-DUSE_FBGEMM=$(usex fbgemm)
		-DUSE_FLASH_ATTENTION=$(usex flash)
		-DUSE_GFLAGS=ON
		-DUSE_GLOG=ON
		-DUSE_GLOO=$(usex gloo)
		-DUSE_ITT=OFF
		-DUSE_KINETO=ON
		-DUSE_KLEIDIAI=OFF # TODO
		-DUSE_MAGMA=OFF # TODO: In GURU as sci-libs/magma
		-DUSE_MEM_EFF_ATTENTION=$(usex memefficient)
		-DUSE_MKLDNN=$(usex onednn)
		-DUSE_MPI=$(usex mpi)
		-DUSE_NCCL=OFF
		-DUSE_NNPACK=$(usex nnpack)
		-DUSE_NUMA=OFF
		-DUSE_NUMPY=$(usex numpy)
		-DUSE_OPENCL=$(usex opencl)
		-DUSE_OPENMP=$(usex openmp)
		-DUSE_PYTORCH_QNNPACK=$(usex qnnpack)
		-DUSE_PYTORCH_METAL=OFF
		-DUSE_ROCM=$(usex rocm)
		-DUSE_SYSTEM_CPUINFO=ON
		-DUSE_SYSTEM_EIGEN_INSTALL=ON
		-DUSE_SYSTEM_FP16=ON
		-DUSE_SYSTEM_FXDIV=ON
		-DUSE_SYSTEM_GLOO=ON
		-DUSE_SYSTEM_NVTX=ON
		-DUSE_SYSTEM_ONNX=ON
		-DUSE_SYSTEM_PSIMD=ON
		-DUSE_SYSTEM_PTHREADPOOL=ON
		-DUSE_SYSTEM_PYBIND11=ON
		-DUSE_SYSTEM_SLEEF=ON
		-DUSE_SYSTEM_XNNPACK=$(usex xnnpack)
		-DUSE_TENSORPIPE=$(usex distributed)
		-DUSE_UCC=OFF
		-DUSE_VALGRIND=OFF
		-DUSE_VULKAN=$(usex vulkan)
		-DUSE_XNNPACK=$(usex xnnpack)
		-DUSE_XPU=OFF
		-DC_AVX_FOUND=$(usex cpu_flags_x86_avx)
		-DC_AVX2_FOUND=$(usex cpu_flags_x86_avx2)
		-DC_AVX512_FOUND=$(usex cpu_flags_x86_avx512f)
		-DCXX_AVX_FOUND=$(usex cpu_flags_x86_avx)
		-DCXX_AVX2_FOUND=$(usex cpu_flags_x86_avx2)
		-DCXX_AVX512_FOUND=$(usex cpu_flags_x86_avx512f)

		-Wno-dev
	)

	if use mkl; then
		mycmakeargs+=(-DBLAS=MKL)
	elif use openblas; then
		mycmakeargs+=(-DBLAS=OpenBLAS)
	else
		mycmakeargs+=(-DBLAS=Generic -DBLAS_LIBRARIES=)
	fi

	if use cuda; then
		addpredict "/dev/nvidiactl" # bug 867706
		addpredict "/dev/char"
		addpredict "/proc/self/task" # bug 926116

		mycmakeargs+=(
			-DUSE_CUDNN=ON
			-DTORCH_CUDA_ARCH_LIST="${TORCH_CUDA_ARCH_LIST:-5.0 7.0}"
			-DUSE_NCCL=OFF # TODO: NVIDIA Collective Communication Library
			-DCMAKE_CUDA_FLAGS="$(cuda_gccdir -f | tr -d \")"
			-DUSE_CUDSS=$(usex cudss)
			-DUSE_CUSPARSELT=ON
		)
	elif use rocm; then
		export PYTORCH_ROCM_ARCH="$(get_amdgpu_flags)"

		if use memefficient; then
			export AOTRITON_INSTALLED_PREFIX="${ESYSROOT}/usr"
		fi

		mycmakeargs+=(
			-DUSE_NCCL=ON
			-DUSE_SYSTEM_NCCL=ON
			-DCMAKE_REQUIRE_FIND_PACKAGE_HIP=ON
		)

		# ROCm libraries produce too much warnings
		append-cxxflags -Wno-deprecated-declarations -Wno-unused-result -Wno-unused-value
	fi

	if use onednn; then
		mycmakeargs+=(
			-DMKLDNN_FOUND=ON
			-DMKLDNN_LIBRARIES=dnnl
			-DMKLDNN_INCLUDE_DIR="${ESYSROOT}/usr/include/oneapi/dnnl"
		)
	fi

	cmake_src_configure
}

src_compile() {
	PYTORCH_BUILD_VERSION=${PV} \
	PYTORCH_BUILD_NUMBER=0 \
	cmake_src_compile
}

python_install() {
	python_domodule python/torch
	mkdir "${D}"$(python_get_sitedir)/torch/bin || die
	mkdir "${D}"$(python_get_sitedir)/torch/lib || die
	mkdir "${D}"$(python_get_sitedir)/torch/include || die
	ln -s ../../../../../include/torch \
		"${D}$(python_get_sitedir)"/torch/include/torch || die # bug 923269
	ln -s ../../../../../bin/torch_shm_manager \
		"${D}"$(python_get_sitedir)/torch/bin/torch_shm_manager || die
	ln -s ../../../../../$(get_libdir)/libtorch_global_deps.so \
		"${D}"$(python_get_sitedir)/torch/lib/libtorch_global_deps.so || die
}

src_install() {
	cmake_src_install

	# Clean up third-party software installs.
	rm -rf "${ED}"/usr/share/cmake/{kineto,fbgemm} \
		"${ED}"/usr/include/{kineto,fbgemm,asmjit} \
		"${ED}"/usr/$(get_libdir)/cmake/asmjit

	# Used by pytorch ebuild
	insinto "/var/lib/${PN}"
	doins "${BUILD_DIR}"/CMakeCache.txt
	dostrip -x /var/lib/${PN}/functorch.so

	rm -rf python
	mkdir -p python/torch || die
	cp torch/version.py python/torch/ || die
	python_install
}
