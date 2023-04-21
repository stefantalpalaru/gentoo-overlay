# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_COMMIT="9cb9f9c4f0073d78b08d6542cebaea6564ecadfe"

inherit cmake

DESCRIPTION="uTorrent Transport Protocol library"
HOMEPAGE="https://github.com/transmission/libutp/"
SRC_URI="https://github.com/transmission/libutp/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
IUSE="tools"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

S="${WORKDIR}/${PN}-${MY_COMMIT}"

PATCHES=(
	"${FILESDIR}/libutp-20180515-bool.patch"
)

src_configure() {
	local mycmakeargs=(
		-DLIBUTP_SHARED=ON
		-DLIBUTP_ENABLE_INSTALL=ON
		-DLIBUTP_ENABLE_WERROR=OFF
		-DLIBUTP_BUILD_PROGRAMS=$(usex tools ON )
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
}
