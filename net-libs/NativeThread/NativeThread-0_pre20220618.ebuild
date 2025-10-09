# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
MY_COMMIT="e0ff693341c64f9f089444fad8c51a85f05438f3"

inherit flag-o-matic java-pkg-2 toolchain-funcs

DESCRIPTION="NativeThread for priorities on Linux for Freenet"
HOMEPAGE="https://github.com/hyphanet/contrib"
SRC_URI="https://github.com/hyphanet/contrib/archive/${MY_COMMIT}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/contrib-${MY_COMMIT}/NativeThread"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64"

CDEPEND="dev-java/jna:4"
DEPEND="
	net-p2p/freenet
	>=virtual/jdk-1.8:*
"
RDEPEND=">=virtual/jre-1.8:*"

PATCHES=(
	"${FILESDIR}/NativeThread-0_pre20220618-javah.patch"
)

src_prepare() {
	default #780585
	cp -a "${FILESDIR}/NativeThread.java" .
	java-pkg-2_src_prepare
}

src_compile() {
	append-flags -fPIC
	tc-export CC
	emake
}

src_install() {
	dolib.so lib${PN}.so
	dosym lib${PN}.so /usr/$(get_libdir)/libnative.so
}
