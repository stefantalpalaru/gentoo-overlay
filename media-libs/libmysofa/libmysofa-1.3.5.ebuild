# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
MY_COMMIT="6cc5b15a73e9bd97810d03767082edda7f315881"

inherit cmake

DESCRIPTION="Reader for AES SOFA files to get better HRTFs"
HOMEPAGE="https://github.com/hoene/libmysofa"
SRC_URI="https://github.com/hoene/libmysofa/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RDEPEND="
	sys-libs/zlib
"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=OFF
		-DBUILD_STATIC_LIBS=$(usex static-libs ON OFF)
	)
	cmake_src_configure
}
