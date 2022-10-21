# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
MY_COMMIT="ce864b17ea0e24a91e77c7dd3eb2d1ac4175b3f0"

DESCRIPTION="Fast Base64 encoding/decoding routines"
HOMEPAGE="https://github.com/libb64/libb64/"
#SRC_URI="https://github.com/libb64/libb64/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="https://github.com/libb64/libb64/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="CC-PD"
# static library, so always rebuild
SLOT="0/${PVR}"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86"

S="${WORKDIR}/libb64-${MY_COMMIT}"

src_compile() {
	# override -O3, -Werror non-sense
	emake -C src CFLAGS="${CFLAGS} -I../include"
}

src_install() {
	dolib.a src/libb64.a
	insinto /usr/include
	doins -r include/b64
	einstalldocs
}
