# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="stack trace visualizer"
HOMEPAGE="http://www.brendangregg.com/flamegraphs.html"
SRC_URI="https://github.com/brendangregg/FlameGraph/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	dev-lang/perl
	virtual/awk
"

S="${WORKDIR}/FlameGraph-${PV}"

src_install() {
	dobin *.pl *.awk
	dodoc README.md
}
