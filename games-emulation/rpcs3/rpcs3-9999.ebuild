# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="PlayStation 3 emulator"
HOMEPAGE="https://rpcs3.net/"
EGIT_REPO_URI="https://github.com/RPCS3/rpcs3"
KEYWORDS=""

LICENSE="GPL-2"
SLOT="0"
IUSE="alsa gdb joystick +llvm pulseaudio vulkan"

RDEPEND="
	>=dev-qt/qtcore-5.7
	>=dev-qt/qtdbus-5.7
	>=dev-qt/qtgui-5.7
	>=dev-qt/qtwidgets-5.7
	alsa? ( media-libs/alsa-lib )
	gdb? ( sys-devel/gdb )
	joystick? ( dev-libs/libevdev )
	llvm? ( sys-devel/llvm:4 )
	media-libs/glew:0
	media-libs/libpng:*
	media-libs/openal
	pulseaudio? ( media-sound/pulseaudio )
	sys-libs/zlib
	virtual/ffmpeg
	virtual/opengl
	vulkan? ( media-libs/vulkan-loader )
	x11-libs/libX11
	"

DEPEND="${RDEPEND}
	>=sys-devel/gcc-5.1
	"

EGIT_SUBMODULES=(
	"*"
	"-rpcs3-ffmpeg"
	"-llvm"
	"-libpng"
	"-rsx-debugger"
	"-3rdparty/zlib"
	"-Vulkan/Vulkan-LoaderAndValidationLayers"
)

src_prepare() {
	default

	sed -i -e '/find_program(CCACHE_FOUND/d' CMakeLists.txt
	sed -i \
		-e 's/llvm_map_components_to_libnames(LLVM_LIBS/llvm_map_components_to_libnames(LLVM_LIBS core support executionengine object runtimedyld x86desc x86info scalaropts/' \
		rpcs3/CMakeLists.txt

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		"-DUSE_SYSTEM_LIBPNG=ON"
		"-DUSE_SYSTEM_FFMPEG=ON"
		"-DUSE_VULKAN=$(usex vulkan ON OFF)"
		"-DUSE_ALSA=$(usex alsa ON OFF)"
		"-DUSE_PULSE=$(usex pulseaudio ON OFF)"
		"-DUSE_LIBEVDEV=$(usex joystick ON OFF)"
		"-DWITH_GDB=$(usex gdb ON OFF)"
		"-DWITHOUT_LLVM=$(usex llvm OFF ON)"
	)

	cmake-utils_src_configure
}
