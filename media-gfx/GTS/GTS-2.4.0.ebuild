# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="scanning tool developed by Studio Ghibli"
HOMEPAGE="https://github.com/opentoonz/GTS"
SRC_URI="https://github.com/opentoonz/GTS/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	media-gfx/sane-backends
	media-libs/tiff:0
	virtual/glu
	x11-libs/fltk
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.4.0-config-file.patch
)

src_prepare() {
	default
	eautoreconf
}
