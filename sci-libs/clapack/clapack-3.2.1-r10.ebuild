# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic cmake

DESCRIPTION="f2c'ed version of LAPACK"
HOMEPAGE="https://www.netlib.org/clapack/"
SRC_URI="https://www.netlib.org/${PN}/${P}-CMAKE.tgz"
S="${WORKDIR}"/${P}-CMAKE
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE="test"
# bug 433806
RESTRICT="test"

RDEPEND="
	>=dev-libs/libf2c-20090407-r1
	virtual/blas"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-fix_include_file.patch"
	"${FILESDIR}/${P}-noblasf2c.patch"
	"${FILESDIR}/${P}-hang.patch"
	"${FILESDIR}/${P}-findblas-r7.patch"
)

src_prepare() {
	cmake_src_prepare
	rm INCLUDE/f2c.h F2CLIBS/libf2c/f2c.h || die
}

src_configure() {
	# causes an internal compiler error with gcc-4.6.2
	filter-flags -ftree-vectorize
	# can't default to gnu23 here
	append-cflags -std=gnu17

	local mycmakeargs=(
		-DENABLE_TESTS=$(usex test)
	)
	cmake_src_configure
}
