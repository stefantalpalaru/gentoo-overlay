# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Ambisonic encoding / decoding and binauralization library in C++"
HOMEPAGE="https://github.com/videolabs/libspatialaudio"
SRC_URI="https://github.com/videolabs/libspatialaudio/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-2.1+"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libmysofa
"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	sed -i -e "s/DESTINATION lib/DESTINATION $(get_libdir)/" \
		CMakeLists.txt

	PATCHES=()
	cmake_src_prepare
}

src_configure() {
	cmake_src_configure
}
