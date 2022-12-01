# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="collection of Kiwix related command line tools"
HOMEPAGE="https://kiwix.org/"
SRC_URI="https://github.com/kiwix/$PN/archive/$PV.tar.gz -> $P.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=www-misc/kiwix-lib-12.0.0
"
RDEPEND="${DEPEND}"

src_configure() {
	local emesonargs=(
		-Dwerror=false
	)

	meson_src_configure
}
