# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="reference implementation for the ZIM archive format"
HOMEPAGE="https://wiki.openzim.org/wiki/OpenZIM
		https://github.com/openzim/libzim"
SRC_URI="https://github.com/openzim/libzim/archive/refs/tags/${PV}.tar.gz -> ${P}-r1.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	app-arch/xz-utils
	app-arch/zstd
	dev-libs/icu
	dev-libs/xapian
"

DEPEND="virtual/pkgconfig"

src_prepare() {
	default

	# Disable GTest automagic: https://github.com/openzim/libzim/issues/757
	sed -i \
		-e "s/gtest_dep = dependency('gtest'/gtest_dep = dependency(''/" \
		meson.build || die
}
