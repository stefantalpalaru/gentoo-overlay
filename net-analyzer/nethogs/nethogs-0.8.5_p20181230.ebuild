# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="A small 'net top' tool, grouping bandwidth by process"
HOMEPAGE="https://github.com/raboof/nethogs"
MY_COMMIT="ac5af1d1b969f189cc4094bb20027f557eb54b34"
SRC_URI="https://github.com/raboof/nethogs/archive/${MY_COMMIT}.zip -> ${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 x86"

RDEPEND="
	net-libs/libpcap
	sys-libs/ncurses:0=
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

S="${WORKDIR}/${PN}-${MY_COMMIT}"

src_compile() {
	tc-export CC CXX
	emake NCURSES_LIBS="$( $(tc-getPKG_CONFIG) --libs ncurses )" ${PN}
}

src_install() {
	emake DESTDIR="${ED}" PREFIX="/usr" install
	dodoc DESIGN README.decpcap.txt README.md
}
