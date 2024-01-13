# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..12} )

inherit cmake git-r3 python-single-r1

DESCRIPTION="PlayStation 3 emulator"
HOMEPAGE="https://rpcs3.net/"
EGIT_REPO_URI="https://github.com/RPCS3/rpcs3"
LICENSE="GPL-2"
SLOT="0"
IUSE="alsa joystick +llvm pulseaudio sdl vulkan"
RESTRICT="network-sandbox"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-libs/pugixml-1.11
	>=dev-qt/qtbase-6.5.2[dbus,gui,widgets]
	>=dev-qt/qtdeclarative-6.5.2:6
	>=dev-qt/qtmultimedia-6.5.2:6
	>=dev-qt/qtsvg-6.5.2:6
	alsa? ( media-libs/alsa-lib )
	dev-debug/gdb
	dev-libs/flatbuffers
	dev-libs/libusb
	dev-libs/xxhash
	joystick? ( dev-libs/libevdev )
	media-libs/glew:0
	media-libs/libpng:*
	media-libs/openal
	pulseaudio? ( media-libs/libpulse )
	sys-libs/zlib
	virtual/opengl
	vulkan? ( media-libs/vulkan-loader )
	x11-libs/libX11
"

DEPEND="${RDEPEND}
	>=sys-devel/gcc-9
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

EGIT_SUBMODULES=(
	"*"
	"-3rdparty/FAudio"
	"-3rdparty/curl"
	"-3rdparty/flatbuffers"
	"-3rdparty/libpng"
	"-3rdparty/libsdl-org/SDL"
	"-3rdparty/libusb"
	"-3rdparty/pugixml"
	"-3rdparty/xxHash"
	"-3rdparty/zlib"
)

PATCHES=(
	"${FILESDIR}/rpcs3-9999-r7-tests.patch"
)

src_prepare() {
	sed -i \
		-e '/find_program(CCACHE_FOUND/d' \
		CMakeLists.txt || die
	sed -i \
		-e '/-Werror/d' \
		buildfiles/cmake/ConfigureCompiler.cmake || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_LLVM=ON
		-DBUILD_SHARED_LIBS=OFF
		-DCMAKE_CXX_FLAGS="${CXXFLAGS}"
		-DCMAKE_C_FLAGS="${CFLAGS}"
		-DUSE_ALSA=$(usex alsa ON OFF)
		-DUSE_DISCORD_RPC=OFF
		-DUSE_FAUDIO=OFF
		-DUSE_LIBEVDEV=$(usex joystick ON OFF)
		-DUSE_NATIVE_INSTRUCTIONS=OFF
		-DUSE_PRECOMPILED_HEADERS=ON
		-DUSE_PULSE=$(usex pulseaudio ON OFF)
		-DUSE_SDL=$(usex sdl)
		-DUSE_SYSTEM_CURL=ON
		-DUSE_SYSTEM_FFMPEG=OFF
		-DUSE_SYSTEM_FLATBUFFERS=ON
		-DUSE_SYSTEM_LIBPNG=ON
		-DUSE_SYSTEM_LIBUSB=ON
		-DUSE_SYSTEM_PUGIXML=ON
		-DUSE_SYSTEM_SDL=ON
		-DUSE_SYSTEM_XXHASH=ON
		-DUSE_SYSTEM_ZLIB=ON
		-DUSE_VULKAN=$(usex vulkan ON OFF)
		-DWITH_LLVM=$(usex llvm ON OFF)
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
