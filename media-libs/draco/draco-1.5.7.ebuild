# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="3D mesh and point-cloud compression library"
HOMEPAGE="https://google.github.io/draco/
	https://github.com/google/draco"
SRC_URI="https://github.com/google/draco/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DDRACO_TESTS=OFF
		-DDRACO_TRANSCODER_SUPPORTED=OFF
	)
	cmake_src_configure
}
