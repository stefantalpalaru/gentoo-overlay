# Copyright 2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="tool that generates tags for Nim files, similar to ctags"
HOMEPAGE="https://bitbucket.org/nimcontrib/ntags"
SRC_URI="https://bitbucket.org/nimcontrib/ntags/get/${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=dev-lang/nim-0.11.0
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/ntags-0.5.0-fix-shallow-segfault.patch"
)

src_unpack() {
	default
	mv nimcontrib-ntags-* "$P"
}

src_compile() {
	nim c -d:release ${PN}.nim || die "compile failed"
}

src_install() {
	exeinto /usr/bin
	doexe ${PN}
}
