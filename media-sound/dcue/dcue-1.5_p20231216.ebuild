# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="generate CUE sheets from Discogs data"
HOMEPAGE="https://github.com/xavery/dcue"
EGIT_REPO_URI="https://github.com/xavery/dcue/"
EGIT_COMMIT="52677cd9dfc71a5878d3fd5090ad034746b66ca2"
LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	net-misc/curl
"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i \
		-e 's/-Werror//' \
		CMakeLists.txt || die

	echo 'install(TARGETS ${PROJECT_NAME} DESTINATION bin)' >> CMakeLists.txt

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs+=(
		-DBUILD_SHARED_LIBS=OFF
	)

	cmake_src_configure
}
