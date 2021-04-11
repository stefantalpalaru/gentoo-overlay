# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic

DESCRIPTION="Geometry library"
HOMEPAGE="http://www.qhull.org"
SRC_URI="https://github.com/qhull/qhull/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="doc static-libs"

DOCS=( Announce.txt File_id.diz README.txt REGISTER.txt )

PATCHES=(
	"${FILESDIR}"/${PN}-2019.1-64bit.patch
	"${FILESDIR}"/${PN}-2019.1-pkg-config.patch
)

src_prepare() {
	sed "s/@VERSION@/${PV}/" "${FILESDIR}"/libqhull.pc.in > build/libqhull.pc.in
	cmake_src_prepare
}

src_configure() {
	append-flags -fno-strict-aliasing
	mycmakeargs+=(
		-DLIB_INSTALL_DIR="${EPREFIX}"/usr/$(get_libdir)
		-DDOC_INSTALL_DIR="${EPREFIX}"/usr/share/doc/${P}/html
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	# compatibility with previous installs
	dosym libqhull /usr/include/qhull
	if ! use doc; then
		rm -rf "${ED}"/usr/share/doc/${P}/html || die
	fi
	if ! use static-libs; then
		rm -f "${ED}"/usr/$(get_libdir)/lib*.a || die
	fi
}
