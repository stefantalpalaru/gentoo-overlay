# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="multicore enabled coroutine library written in C"
HOMEPAGE="https://github.com/halayli/lthread"
EGIT_REPO_URI="https://github.com/halayli/lthread"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE="+debug static-libs"
RESTRICT="debug" # this library needs its asserts to work

src_prepare() {
	sed -i \
		-e '/COMPILE_FLAGS/d' \
		-e "s/DESTINATION lib/DESTINATION $(get_libdir)/" \
		CMakeLists.txt
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
	)
	cmake_src_configure

	if use static-libs; then
		mycmakeargs=(
				-DBUILD_SHARED_LIBS=OFF
			)
		BUILD_DIR=${BUILD_DIR}_static cmake_src_configure
	fi
}

src_compile() {
	cmake_src_compile

	if use static-libs; then
		BUILD_DIR=${BUILD_DIR}_static cmake_src_compile
	fi
}

src_install() {
	if use static-libs; then
		BUILD_DIR=${BUILD_DIR}_static cmake_src_install
	fi

	cmake_src_install
}
