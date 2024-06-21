# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Audio plugin bundle over the LV2 standard for Linux"
HOMEPAGE="http://eq10q.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-cpp/gtkmm:2.4
	media-libs/lv2
	>=sci-libs/fftw-3
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}/replace_pow10.patch"
	"${FILESDIR}/fix_lv2.patch"
)

src_configure() {
	local mycmakeargs=(
		"-DCMAKE_INSTALL_PREFIX=/usr/$(get_libdir)/lv2"
	)
	cmake_src_configure
}
