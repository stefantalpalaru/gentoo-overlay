# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..10} )

inherit cmake git-r3 python-single-r1

DESCRIPTION="PlayStation 3 emulator"
HOMEPAGE="https://rpcs3.net/"
EGIT_REPO_URI="https://github.com/RPCS3/rpcs3"
KEYWORDS=""
LICENSE="GPL-2"
SLOT="0"
IUSE="alsa joystick +llvm pulseaudio vulkan"
RESTRICT="network-sandbox"

RDEPEND="
	>=dev-libs/pugixml-1.11
	>=dev-qt/qtcore-5.15.2
	>=dev-qt/qtdbus-5.15.2
	>=dev-qt/qtgui-5.15.2
	>=dev-qt/qtsvg-5.15.2
	>=dev-qt/qtwidgets-5.15.2
	alsa? ( media-libs/alsa-lib )
	sys-devel/gdb
	joystick? ( dev-libs/libevdev )
	media-libs/glew:0
	media-libs/libpng:*
	media-libs/openal
	media-video/ffmpeg
	pulseaudio? ( media-sound/pulseaudio )
	sys-libs/zlib
	virtual/opengl
	vulkan? ( media-libs/vulkan-loader )
	x11-libs/libX11
"

DEPEND="${RDEPEND}
	>=sys-devel/gcc-9
"

EGIT_SUBMODULES=(
	"*"
	"-3rdparty/FAudio"
	"-3rdparty/curl"
	"-3rdparty/ffmpeg"
	"-3rdparty/libpng"
	"-3rdparty/pugixml"
	"-3rdparty/zlib"
)

src_prepare() {
	default

	sed -i \
		-e '/find_program(CCACHE_FOUND/d' \
		CMakeLists.txt
	sed -i \
		-e 's/DEBUG|RELEASE|RELWITHDEBINFO|MINSIZEREL/DEBUG|RELEASE|RELWITHDEBINFO|MINSIZEREL|GENTOO/' \
		llvm/CMakeLists.txt
	sed -i \
		-e '/-Werror/d' \
		buildfiles/cmake/ConfigureCompiler.cmake

	cmake_src_prepare
}

src_configure() {
	# We can't use precompiled headers due to https://github.com/RPCS3/rpcs3/issues/8443
	local mycmakeargs=(
		-DUSE_NATIVE_INSTRUCTIONS=OFF
		-DWITH_LLVM=$(usex llvm ON OFF)
		-DUSE_ALSA=$(usex alsa ON OFF)
		-DUSE_DISCORD_RPC=OFF
		-DUSE_PULSE=$(usex pulseaudio ON OFF)
		-DUSE_FAUDIO=OFF
		-DUSE_LIBEVDEV=$(usex joystick ON OFF)
		-DUSE_VULKAN=$(usex vulkan ON OFF)
		-DUSE_PRECOMPILED_HEADERS=OFF
		-DUSE_SYSTEM_LIBPNG=ON
		-DUSE_SYSTEM_FFMPEG=ON
		-DUSE_SYSTEM_CURL=ON
		-DUSE_SYSTEM_PUGIXML=ON
		-DCMAKE_C_FLAGS="${CFLAGS}"
		-DCMAKE_C_FLAGS_GENTOO="${CFLAGS}"
		-DCMAKE_CXX_FLAGS="${CXXFLAGS}"
		-DCMAKE_CXX_FLAGS_GENTOO="${CXXFLAGS}"
		-DBUILD_SHARED_LIBS=OFF
	)
	# https://github.com/RPCS3/rpcs3/pull/8609
	if use vulkan; then
		mycmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_Wayland=TRUE )
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install

	mv "${ED}"/usr/bin/rpcs3 "${ED}"/usr/bin/rpcs3.bin
	cat <<EOF > "${T}"/rpcs3
#!/bin/sh

# https://github.com/RPCS3/rpcs3/issues/7772
export QT_AUTO_SCREEN_SCALE_FACTOR=0

exec rpcs3.bin
EOF
	dobin "${T}"/rpcs3
}
