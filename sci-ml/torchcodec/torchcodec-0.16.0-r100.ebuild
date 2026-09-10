# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=scikit-build-core
DISTUTILS_EXT=1

inherit cuda cuda-extra distutils-r1

DESCRIPTION="Media decoding and encoding for PyTorch: videos, images, and audio"
HOMEPAGE="https://github.com/pytorch/torchcodec"
SRC_URI="https://github.com/pytorch/torchcodec/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="avif cuda gif heif +jpeg +png rocm +webp"
RESTRICT="network-sandbox"

RDEPEND="
	dev-python/numpy
	dev-python/pillow
	avif? ( media-libs/libavif:= )
	gif? ( media-libs/giflib:= )
	heif? ( media-libs/libheif:= )
	jpeg? ( media-libs/libjpeg-turbo:= )
	png? ( media-libs/libpng:= )
	$(python_gen_cond_dep '
		dev-python/pybind11[${PYTHON_USEDEP}]
	')
	webp? ( media-libs/libwebp:= )
	media-video/ffmpeg
	sci-ml/pytorch[${PYTHON_SINGLE_USEDEP},cuda?,rocm?]
"
DEPEND="${RDEPEND}"

distutils_enable_tests pytest

src_prepare() {
	if use cuda; then
		export CUDA_HOME="${EPREFIX}/opt/cuda"
		export NVCC_FLAGS="$(cuda_gcc -f | tr -d \")"
		cuda_add_sandbox -w
		addpredict "/proc/self/task" # bug 926116
		addpredict "/dev/char/"
	fi

	if use cuda || use rocm; then
	  export ENABLE_CUDA=1
	fi

	export I_CONFIRM_THIS_IS_NOT_A_LICENSE_VIOLATION=1
	export TORCHCODEC_BUILD_JPEG=$(usex jpeg 1 0)
	export TORCHCODEC_BUILD_PNG=$(usex png 1 0)
	export TORCHCODEC_BUILD_WEBP=$(usex webp 1 0)
	export WebP_DIR="${T}/cmake"
	export TORCHCODEC_BUILD_AVIF=$(usex avif 1 0)
	export TORCHCODEC_BUILD_GIF=$(usex gif 1 0)
	export TORCHCODEC_BUILD_HEIC=$(usex heif 1 0)
	export TORCHCODEC_BUILD_NVJPEG=$(usex cuda 1 0)

	export BUILD_TESTS=$(usex test 1 0)

	###############################################################
	# Insane stuff from main tree's openimageio-3.1.7.0-r1.ebuild #
	###############################################################
	mkdir "${T}/cmake" || die

	local libdir="${ESYSROOT}/usr/$(get_libdir)"

	# generate our own WebPConfig.cmake via pkg-config # 937031
	cat <<-EOF > "${T}/cmake/WebPConfig.cmake" || die
	set(WebP_VERSION $(pkg-config --modversion libwebp))
	set(WEBP_VERSION \${WebP_VERSION})

	set_and_check(WebP_INCLUDE_DIR "$(pkg-config --variable includedir libwebp)")
	set(WebP_INCLUDE_DIRS \${WebP_INCLUDE_DIR})
	set(WEBP_INCLUDE_DIRS \${WebP_INCLUDE_DIR})
	set(WebP_LIBRARIES "webp")
	set(WEBP_LIBRARIES "\${WebP_LIBRARIES}")

	# Create imported target WebP::sharpyuv
	add_library(WebP::sharpyuv SHARED IMPORTED)

	set_target_properties(WebP::sharpyuv PROPERTIES
		INTERFACE_INCLUDE_DIRECTORIES "\${WebP_INCLUDE_DIR};\${WebP_INCLUDE_DIR}/webp"
		INTERFACE_LINK_LIBRARIES "m"
	)

	# Create imported target WebP::webp
	add_library(WebP::webp SHARED IMPORTED)

	set_target_properties(WebP::webp PROPERTIES
		INTERFACE_INCLUDE_DIRECTORIES "\${WebP_INCLUDE_DIR}"
		INTERFACE_LINK_LIBRARIES "WebP::sharpyuv;Threads::Threads;m"
	)

	# Create imported target WebP::webpdemux
	add_library(WebP::webpdemux SHARED IMPORTED)

	set_target_properties(WebP::webpdemux PROPERTIES
		INTERFACE_INCLUDE_DIRECTORIES "\${WebP_INCLUDE_DIR}"
		INTERFACE_LINK_LIBRARIES "WebP::webp"
	)

	# Create imported target WebP::libwebpmux
	add_library(WebP::libwebpmux SHARED IMPORTED)

	set_target_properties(WebP::libwebpmux PROPERTIES
		INTERFACE_INCLUDE_DIRECTORIES "\${WebP_INCLUDE_DIR}"
		INTERFACE_LINK_LIBRARIES "WebP::webp"
	)

	# Import target "WebP::webp" for configuration "RelWithDebInfo"
	set_property(TARGET WebP::webp APPEND PROPERTY IMPORTED_CONFIGURATIONS RELWITHDEBINFO)
	set_target_properties(WebP::webp PROPERTIES
		IMPORTED_LINK_INTERFACE_LANGUAGES_RELWITHDEBINFO "C"
		IMPORTED_LOCATION_RELWITHDEBINFO "${libdir}/libwebp.so"
	)

	list(APPEND _cmake_import_check_targets WebP::webp )
	list(APPEND _cmake_import_check_files_for_WebP::webp "${libdir}/libwebp.so" )

	# Import target "WebP::webpdemux" for configuration "RelWithDebInfo"
	set_property(TARGET WebP::webpdemux APPEND PROPERTY IMPORTED_CONFIGURATIONS RELWITHDEBINFO)
	set_target_properties(WebP::webpdemux PROPERTIES
		IMPORTED_LINK_INTERFACE_LANGUAGES_RELWITHDEBINFO "C"
		IMPORTED_LOCATION_RELWITHDEBINFO "${libdir}/libwebpdemux.so"
	)

	list(APPEND _cmake_import_check_targets WebP::webpdemux )
	list(APPEND _cmake_import_check_files_for_WebP::webpdemux "${libdir}/libwebpdemux.so" )

	# Import target "WebP::sharpyuv" for configuration "RelWithDebInfo"
	set_property(TARGET WebP::sharpyuv APPEND PROPERTY IMPORTED_CONFIGURATIONS RELWITHDEBINFO)
	set_target_properties(WebP::sharpyuv PROPERTIES
		IMPORTED_LINK_INTERFACE_LANGUAGES_RELWITHDEBINFO "C"
		IMPORTED_LOCATION_RELWITHDEBINFO "${libdir}/libsharpyuv.so"
	)

	list(APPEND _cmake_import_check_targets WebP::sharpyuv )
	list(APPEND _cmake_import_check_files_for_WebP::sharpyuv "${libdir}/libsharpyuv.so" )

	# Import target "WebP::libwebpmux" for configuration "RelWithDebInfo"
	set_property(TARGET WebP::libwebpmux APPEND PROPERTY IMPORTED_CONFIGURATIONS RELWITHDEBINFO)
	set_target_properties(WebP::libwebpmux PROPERTIES
		IMPORTED_LINK_INTERFACE_LANGUAGES_RELWITHDEBINFO "C"
		IMPORTED_LOCATION_RELWITHDEBINFO "${libdir}/libwebpmux.so"
	)

	list(APPEND _cmake_import_check_targets WebP::libwebpmux )
	list(APPEND _cmake_import_check_files_for_WebP::libwebpmux "${libdir}/libwebpmux.so" )

	check_required_components(WebP)
	EOF

	###

	use cuda && cuda_src_prepare_extra
	distutils-r1_src_prepare
}

python_test() {
	if use cuda; then
		cuda_add_sandbox -w
		addwrite "/proc/self/task"
		addpredict "/dev/char/"
		cuda_check_permissions || die "Cannot access CUDA device. Aborting."
	fi

	local EPYTEST_IGNORE=(
	)
	local EPYTEST_DESELECT=(
	)
	epytest
}
