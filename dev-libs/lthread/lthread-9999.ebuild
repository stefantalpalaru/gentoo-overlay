# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils git-r3

DESCRIPTION="multicore enabled coroutine library written in C"
HOMEPAGE="https://github.com/halayli/lthread"
EGIT_REPO_URI="https://github.com/halayli/lthread"
EGIT_CLONE_TYPE="shallow"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE="+debug static-libs test"
RESTRICT="debug" # this library needs its asserts to work

DEPEND=""
RDEPEND=""

src_prepare() {
	sed -i -e '/COMPILE_FLAGS/d' CMakeLists.txt
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build test TESTING)
		-DBUILD_SHARED_LIBS=ON
	)
	cmake-utils_src_configure

	if use static-libs; then
		mycmakeargs=(
				$(cmake-utils_use_build test TESTING)
				-DBUILD_SHARED_LIBS=OFF
			)
		BUILD_DIR=${BUILD_DIR}_static cmake-utils_src_configure
	fi
}

src_compile() {
	cmake-utils_src_compile

	if use static-libs; then
		BUILD_DIR=${BUILD_DIR}_static cmake-utils_src_compile
	fi
}

src_install() {
	if use static-libs; then
		BUILD_DIR=${BUILD_DIR}_static cmake-utils_src_install
	fi

	cmake-utils_src_install
}
