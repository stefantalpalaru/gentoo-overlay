# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
CMAKE_IN_SOURCE_BUILD=1
PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_EXT=1
ROCM_VERSION="5.7.1"
LLVM_COMPAT=( 17 18 19 20 )
LLVM_OPTIONAL=1

inherit cmake cuda cuda-extra distutils-r1 flag-o-matic llvm-r1 rocm toolchain-funcs

DESCRIPTION="Cross-platform inference and training machine-learning accelerator."
HOMEPAGE="https://onnxruntime.ai
		https://github.com/microsoft/onnxruntime"
SAFEINT_COMMIT=3.0.28
FLATBUFFERS_PV=23.5.26
DATE_PV=3.0.1
DLPACK_PV=0.6
SRC_URI="
	https://github.com/microsoft/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/dcleblanc/SafeInt/archive/${SAFEINT_COMMIT}.tar.gz -> SafeInt-${SAFEINT_COMMIT:0:10}.tar.gz
	https://github.com/google/flatbuffers/archive/v${FLATBUFFERS_PV}.tar.gz -> flatbuffers-${FLATBUFFERS_PV}.tar.gz
	https://github.com/HowardHinnant/date/archive/v${DATE_PV}.tar.gz -> hhdate-${DATE_PV}.tar.gz
	https://github.com/dmlc/dlpack/archive/refs/tags/v${DLPACK_PV}.tar.gz -> dlpack-${DLPACK_PV}.tar.gz
"
LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
CPU_FLAGS="cpu_flags_x86_avx cpu_flags_x86_avx2 cpu_flags_x86_avx512f"
IUSE="benchmark cuda onednn cudnn debug hip +python migraphx mimalloc lto test tensorrt llvm xnnpack
${CPU_FLAGS}"
RESTRICT="mirror test"
REQUIRED_USE="
	cuda? ( cudnn !lto )
	hip? ( migraphx )
	|| ( cudnn migraphx onednn tensorrt )
"

RDEPEND="
	dev-libs/protobuf:=
"

BDEPEND="
	${PYTHON_DEPS}
	app-admin/chrpath
	benchmark? ( dev-cpp/benchmark )
	cuda? (
		dev-libs/cutlass:=
		>=dev-util/nvidia-cuda-toolkit-12:=
	)
	cudnn? (
		dev-libs/cudnn:=
		sci-ml/cudnn-frontend:=
	)
	>dev-cpp/eigen-3.4.0:=[cuda?]
	dev-cpp/ms-gsl:=
	dev-cpp/nlohmann_json
	sci-ml/FP16
	dev-libs/FXdiv
	dev-libs/clog:=
	dev-libs/cpuinfo:=
	dev-libs/date:=
	dev-libs/protobuf:=
	dev-libs/re2
	hip? (
		sci-libs/hipFFT:=
		sci-libs/hipCUB:=
		>=dev-libs/rocr-runtime-${ROCM_VERSION}:=
		>=dev-util/hip-${ROCM_VERSION}:=
	)
	mimalloc? ( dev-libs/mimalloc )
	onednn? ( sci-ml/oneDNN:= )
	python? (
		$(python_gen_cond_dep '
			dev-python/cerberus[${PYTHON_USEDEP}]
			dev-python/coloredlogs[${PYTHON_USEDEP}]
			dev-python/flatbuffers[${PYTHON_USEDEP}]
			dev-python/h5py[${PYTHON_USEDEP}]
			dev-python/numpy[${PYTHON_USEDEP}]
			dev-python/psutil[${PYTHON_USEDEP}]
			dev-python/py-cpuinfo[${PYTHON_USEDEP}]
			dev-python/sympy[${PYTHON_USEDEP}]
		')
	)
	sci-ml/onnx:=[disableStaticReg]
	sci-ml/pytorch
	xnnpack? ( sci-ml/XNNPACK )
"

PATCHES=(
	"${FILESDIR}/${PN}-system-dnnl.patch"
	"${FILESDIR}/re2-pkg-config-r4.patch"
	"${FILESDIR}/system-onnx-r5.patch"
	"${FILESDIR}/system-composable_kernel-r4.patch"
	"${FILESDIR}/system-protobuf-r1.patch"
	"${FILESDIR}/system-mp11.patch"
	"${FILESDIR}/system-gsl-r4.patch"
	#"${FILESDIR}/rocm-version-override-r2.patch"
	"${FILESDIR}/hip-gentoo.patch"
	"${FILESDIR}/shared-build-fix.patch"
	"${FILESDIR}/hip-libdir.patch"
	"${FILESDIR}/contrib-ops.patch"
	"${FILESDIR}/disabled_rules_and_transformers.patch"
	"${FILESDIR}/Werror.patch"
	"${FILESDIR}/onnxruntime-1.19.0-abseil.patch"
	"${FILESDIR}/onnxruntime-1.19.0-eigen.patch"
	"${FILESDIR}/onnxruntime-1.21.0-system-eigen.patch"
	"${FILESDIR}/onnxruntime-1.20.0-cudnn_frontend.patch"
	"${FILESDIR}/onnxruntime-1.21.0-external-downloads.patch"
	"${FILESDIR}/onnxruntime-1.21.1-gcc-15.patch"
	"${FILESDIR}/onnxruntime-1.22.2-onnx-1.18.patch"
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
	use llvm && llvm-r1_pkg_setup
}

src_prepare() {
	CMAKE_USE_DIR="${S}/cmake"

	if use python; then
		export PYTHONPATH="${S}/onnxruntime/python:${PYTHONPATH}"
		python_setup
	fi

	use cuda && cuda_src_prepare

	# Workaround for binary drivers.
	addpredict /dev/ati
	addpredict /dev/dri
	addpredict /dev/nvidiactl

	# fix build with gcc12(?), take idea from https://github.com/microsoft/onnxruntime/pull/11667 and https://github.com/microsoft/onnxruntime/pull/10014
	sed 's|dims)|TensorShape(dims))|g' \
		-i onnxruntime/contrib_ops/cuda/quantization/qordered_ops/qordered_qdq.cc || die "Sed failed"

	# fix missing #include <iostream>
	sed '11a#include <iostream>' -i orttraining/orttraining/test/training_api/trainer/trainer.cc

	sed 's/\"-mavx512f\"/\"-mavx512f -Wno-error\"/g' -i cmake/onnxruntime_mlas.cmake || die "Sed failed"

	#if use tensorrt; then
		## Tensorrt 8.6 EA
		#eapply "${FILESDIR}/15089.diff"

		## Update Tensorboard 00d59e65d866a6d4b9fe855dce81ee6ba8b40c4f
		#sed -e 's|373eb09e4c5d2b3cc2493f0949dc4be6b6a45e81|00d59e65d866a6d4b9fe855dce81ee6ba8b40c4f|g' \
			#-e 's|67b833913605a4f3f499894ab11528a702c2b381|ff427b6a135344d86b65fa2928fbd29886eefaec|g' \
			#-i cmake/deps.txt || die sed "Sed failed"
					## Update onnx_tensorrt 6872a9473391a73b96741711d52b98c2c3e25146
					#sed -e 's|369d6676423c2a6dbf4a5665c4b5010240d99d3c|6872a9473391a73b96741711d52b98c2c3e25146|g' \
						#-e 's|62119892edfb78689061790140c439b111491275|75462057c95f7fdbc256179f0a0e9e4b7be28ae3|g' \
						#-i cmake/deps.txt || die sed "Sed failed"
	#fi

	strip-unsupported-flags
	append-flags -Wa,--noexecstack

	cmake_src_prepare

	# for some reason, "patch -p1" can't handle a path like "a/../foo/bar"
	cd ..
	patch -p0 -i "${FILESDIR}/onnxruntime-1.22.0-cmake-4.patch"
}

src_configure() {
	export ROCM_PATH=/usr MIOPEN_PATH=/usr
	export ROCM_VERSION

	use python && python_setup
	CMAKE_BUILD_TYPE=$(usex debug RelWithDebInfo Release)
	CMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
	CMAKE_TLS_VERIFY=ON
	PYTHON_EXECUTABLE="/usr/bin/${EPYTHON}"
	PYTHON_INCLUDE_DIR="$(python_get_includedir)"
	PYTHON_LIBRARY="$(python_get_library_path)"

	append-cxxflags -Wno-dangling-reference -Wno-c++20-compat

	local mycmakeargs=(
		-DCMAKE_INSTALL_INCLUDEDIR="include/${PN}"
		-Donnxruntime_REQUIRE_PYTHON_EMBED_LIB=OFF
		-Donnxruntime_USE_FULL_PROTOBUF=OFF
		-Donnxruntime_ENABLE_LANGUAGE_INTEROP_OPS=OFF
		-Donnxruntime_BUILD_SHARED_LIB=ON
		-Donnxruntime_ENABLE_PYTHON=$(usex python)
		-Donnxruntime_BUILD_BENCHMARKS=$(usex benchmark)
		-Donnxruntime_BUILD_UNIT_TESTS=$(usex test)
		-Donnxruntime_RUN_ONNX_TESTS=$(usex test)
		-Donnxruntime_ENABLE_LAZY_TENSOR=OFF
		-Donnxruntime_USE_PREINSTALLED_EIGEN=ON
		-Donnxruntime_USE_DNNL=$(usex onednn)
		-Donnxruntime_USE_CUDA=$(usex cuda)
		-Donnxruntime_USE_ROCM=$(usex hip)
		-Donnxruntime_USE_AVX=$(usex cpu_flags_x86_avx)
		-Donnxruntime_USE_AVX2=$(usex cpu_flags_x86_avx2)
		-Donnxruntime_USE_AVX512=$(usex cpu_flags_x86_avx512f)
		-Donnxruntime_USE_MIMALLOC=$(usex mimalloc)
		-Donnxruntime_USE_XNNPACK=$(usex xnnpack)
		-Donnxruntime_ENABLE_LTO=$(usex lto)
		-DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS
		-DFETCHCONTENT_FULLY_DISCONNECTED=ON
		-DFETCHCONTENT_QUIET=OFF
		-DFETCHCONTENT_SOURCE_DIR_SAFEINT="${WORKDIR}/SafeInt-${SAFEINT_COMMIT}"
		-DFETCHCONTENT_SOURCE_DIR_FLATBUFFERS="${WORKDIR}/flatbuffers-${FLATBUFFERS_PV}"
		-DFETCHCONTENT_SOURCE_DIR_DATE="${WORKDIR}/date-${DATE_PV}"
		-DFETCHCONTENT_SOURCE_DIR_DLPACK="${WORKDIR}/dlpack-${DLPACK_PV}"
		-Donnxruntime_USE_TENSORRT=$(usex tensorrt)
		-Donnxruntime_USE_JSEP=OFF
		-Donnxruntime_ENABLE_MEMORY_PROFILE=OFF
		-Donnxruntime_DISABLE_ABSEIL=ON
		-Donnxruntime_BUILD_FOR_NATIVE_MACHINE=OFF
		-Donnxruntime_USE_MIMALLOC=OFF
		-Donnxruntime_BUILD_CSHARP=OFF
		-Donnxruntime_BUILD_JAVA=OFF
		-Donnxruntime_BUILD_NODEJS=OFF
		-Donnxruntime_BUILD_OBJC=OFF
		-Donnxruntime_BUILD_APPLE_FRAMEWORK=OFF
		-Donnxruntime_USE_NNAPI_BUILTIN=OFF
		-Donnxruntime_USE_RKNPU=OFF
		-Donnxruntime_ENABLE_MICROSOFT_INTERNAL=OFF
		-Donnxruntime_USE_VITISAI=OFF
		-Donnxruntime_USE_TENSORRT_BUILTIN_PARSER=OFF
		-Donnxruntime_USE_MIGRAPHX=$(usex migraphx)
		-Donnxruntime_CROSS_COMPILING=$(tc-is-cross-compiler && echo ON || echo OFF)
		-Donnxruntime_DISABLE_CONTRIB_OPS=ON
		-Donnxruntime_DISABLE_ML_OPS=ON
		-Donnxruntime_DISABLE_RTTI=OFF
		-Donnxruntime_DISABLE_EXCEPTIONS=$(usex !debug)
		-Donnxruntime_MINIMAL_BUILD=OFF
		-Donnxruntime_EXTENDED_MINIMAL_BUILD=OFF
		-Donnxruntime_MINIMAL_BUILD_CUSTOM_OPS=OFF
		-Donnxruntime_REDUCED_OPS_BUILD=OFF
		-Donnxruntime_ENABLE_LANGUAGE_INTEROP_OPS=OFF
		-Donnxruntime_USE_DML=OFF
		-Donnxruntime_USE_WINML=OFF
		-Donnxruntime_BUILD_MS_EXPERIMENTAL_OPS=OFF
		-Donnxruntime_USE_TELEMETRY=OFF
		-Donnxruntime_USE_ACL=OFF
		-Donnxruntime_USE_ARMNN=OFF
		-Donnxruntime_ARMNN_RELU_USE_CPU=ON
		-Donnxruntime_ARMNN_BN_USE_CPU=ON
		-Donnxruntime_ENABLE_NVTX_PROFILE=OFF
		-Donnxruntime_ENABLE_TRAINING=OFF
		-Donnxruntime_ENABLE_TRAINING_OPS=OFF
		-Donnxruntime_ENABLE_TRAINING_APIS=OFF
		-Donnxruntime_ENABLE_CPU_FP16_OPS=OFF
		-Donnxruntime_USE_NCCL=OFF
		-Donnxruntime_GCOV_COVERAGE=OFF
		-Donnxruntime_ENABLE_MEMORY_PROFILE=OFF
		-Donnxruntime_BUILD_WEBASSEMBLY_STATIC_LIB=OFF
		-Donnxruntime_ENABLE_WEBASSEMBLY_EXCEPTION_CATCHING=ON
		-Donnxruntime_ENABLE_WEBASSEMBLY_API_EXCEPTION_CATCHING=OFF
		-Donnxruntime_ENABLE_WEBASSEMBLY_EXCEPTION_THROWING=ON
		-Donnxruntime_WEBASSEMBLY_RUN_TESTS_IN_BROWSER=OFF
		-Donnxruntime_ENABLE_WEBASSEMBLY_THREADS=OFF
		-Donnxruntime_ENABLE_WEBASSEMBLY_DEBUG_INFO=OFF
		-Donnxruntime_ENABLE_WEBASSEMBLY_PROFILING=OFF
		-Donnxruntime_ENABLE_EAGER_MODE=OFF
		-Donnxruntime_ENABLE_LAZY_TENSOR=OFF
		-Donnxruntime_ENABLE_EXTERNAL_CUSTOM_OP_SCHEMAS=OFF
		-Donnxruntime_ENABLE_ROCM_PROFILING=OFF
		-Donnxruntime_USE_CANN=OFF
		-Donnxruntime_PYBIND_EXPORT_OPSCHEMA=OFF
		-Donnxruntime_ENABLE_MEMLEAK_CHECKER=ON
	)

	if use cuda; then
		local cuda_architectures_real="$(cuda_get_host_native_arch | sed -e 's/$/-real/g' -e 's/;/-real;/g')"
		mycmakeargs+=(
			-Donnxruntime_CUDA_HOME=/opt/cuda
			-Donnxruntime_CUDNN_HOME=/usr
			-DCMAKE_CUDA_ARCHITECTURES="${cuda_architectures_real%%;}"
			-DCMAKE_CUDA_HOST_COMPILER="$(cuda_gccdir)"
			-DCMAKE_CUDA_FLAGS="-forward-unknown-opts -fno-lto ${NVCCFLAGS}"
			-DCMAKE_CUDA_STANDARD_REQUIRED=ON
			-DCMAKE_CXX_STANDARD_REQUIRED=ON
			-Donnxruntime_ENABLE_CUDA_LINE_NUMBER_INFO=OFF
			-Donnxruntime_ENABLE_CUDA_PROFILING=OFF
			-Donnxruntime_USE_NCCL=OFF # Multi GPU CUDA
			-Donnxruntime_NVCC_THREADS=1
		)
	fi

	if use hip; then
		mycmakeargs+=(
		-DCMAKE_HIP_COMPILER="$(get_llvm_prefix)/bin/clang++"
		-DCMAKE_HIP_ARCHITECTURES="$(get_amdgpu_flags)"
	)
	fi

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use python; then
		cd cmake
		cp -a ../{setup.py,pyproject.toml,docs} .
		distutils-r1_src_compile
	fi
}

src_install() {
	cmake_src_install

	if use python; then
		cd cmake
		distutils-r1_src_install
	fi
}
