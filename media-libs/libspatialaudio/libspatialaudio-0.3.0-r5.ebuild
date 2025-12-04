# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Ambisonic encoding / decoding and binauralization library in C++"
HOMEPAGE="https://github.com/videolabs/libspatialaudio"
SRC_URI="https://github.com/videolabs/libspatialaudio/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-2.1+"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RDEPEND="
	media-libs/libmysofa
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/libspatialaudio-0.3.0-dynamic-lib.patch"
)

src_prepare() {
	default

	sed -i -e "s/DESTINATION lib/DESTINATION $(get_libdir)/" \
		CMakeLists.txt

	PATCHES=()
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_STATIC_LIBS=$(usex static-libs ON OFF)
	)
	cmake_src_configure
}
