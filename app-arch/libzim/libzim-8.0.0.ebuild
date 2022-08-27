# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="reference implementation for the ZIM archive format"
HOMEPAGE="https://wiki.openzim.org/wiki/OpenZIM
		https://github.com/openzim/libzim"
SRC_URI="https://github.com/openzim/$PN/archive/$PV.tar.gz -> $P.tar.gz"

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
