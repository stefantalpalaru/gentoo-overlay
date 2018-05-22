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
	media-libs/glew:0
	media-libs/tiff:0
	virtual/glu
	x11-libs/fltk
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eautoreconf
}
