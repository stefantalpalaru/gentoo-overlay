# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Reader for AES SOFA files to get better HRTFs"
HOMEPAGE="https://github.com/hoene/libmysofa"
SRC_URI="https://github.com/hoene/libmysofa/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RDEPEND="
	sys-libs/zlib
"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	sed -i -e "s/DESTINATION lib/DESTINATION $(get_libdir)/" \
		src/CMakeLists.txt

	if ! use static-libs; then
		sed -i -e '/mysofa-static/d' \
			-e '/ARCHIVE DESTINATION/d' \
			src/CMakeLists.txt
	fi

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=OFF
	)
	cmake-utils_src_configure
}
