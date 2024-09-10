# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="stack trace visualizer"
HOMEPAGE="http://www.brendangregg.com/flamegraphs.html"
SRC_URI="https://github.com/brendangregg/FlameGraph/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/FlameGraph-${PV}"
LICENSE="CDDL"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-lang/perl
	app-alternatives/awk
"

src_install() {
	dobin *.pl *.awk
	dodoc README.md
}
