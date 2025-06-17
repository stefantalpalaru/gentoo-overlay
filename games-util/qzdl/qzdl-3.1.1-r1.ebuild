# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

MY_PV=$(ver_rs 0-1 -)

DESCRIPTION="Qt version of BioHazard's ZDoom Launcher (ZDL)"
HOMEPAGE="https://github.com/lcferrum/qzdl"
SRC_URI="https://github.com/lcferrum/qzdl/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/qzdl-3.1.1-qt5-linux.patch" # https://github.com/lcferrum/qzdl/pull/11
)

src_configure() {
	eqmake5
}

src_install() {
	newbin release/zdl qzdl
}
