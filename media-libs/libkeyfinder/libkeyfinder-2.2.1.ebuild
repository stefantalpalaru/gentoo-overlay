# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

DESCRIPTION="Musical key detection library for digital audio"
HOMEPAGE="https://github.com/ibsh/libKeyFinder"
SRC_URI="https://github.com/ibsh/libKeyFinder/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	sci-libs/fftw:3.0
"
DEPEND="${RDEPEND}
	dev-qt/qtcore:5
"

S=${WORKDIR}/libKeyFinder-${PV}

PATCHES=(
	"${FILESDIR}"/libkeyfinder-2.2.1-memset.patch
)

src_prepare() {
	default
	sed -i -e "s#target.path = /usr/lib#target.path = /usr/$(get_libdir)#" LibKeyFinder.pro || die
}

src_configure() {
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${ED}" install
	chmod 644 "${ED}"/usr/include/keyfinder/* || die
}
