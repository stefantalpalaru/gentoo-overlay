# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
MY_COMMIT="7aa1a10277e79642fe900552825b5e37f4fb6425"

inherit cmake

DESCRIPTION="Reader for AES SOFA files to get better HRTFs"
HOMEPAGE="https://github.com/hoene/libmysofa"
#SRC_URI="https://github.com/hoene/libmysofa/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="https://github.com/hoene/libmysofa/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RDEPEND="
	sys-libs/zlib
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/libmysofa-${MY_COMMIT}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=OFF
		-DBUILD_STATIC_LIBS=$(usex static-libs ON OFF)
	)
	cmake_src_configure
}
