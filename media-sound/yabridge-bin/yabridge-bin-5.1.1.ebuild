# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A modern and transparent way to use Windows VST2, VST3 and CLAP plugins on Linux"
HOMEPAGE="https://github.com/robbert-vdh/yabridge/"
SRC_URI="https://github.com/robbert-vdh/yabridge/releases/download/${PV}/yabridge-${PV}.tar.gz"
S="${WORKDIR}/yabridge"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="strip"

RDEPEND=(
	virtual/wine
)

src_compile() { :; }

src_install() {
	dobin yabridgectl *.exe yabridge*.so
	dolib.so libyabridge*.so
	dodoc README.md
}
