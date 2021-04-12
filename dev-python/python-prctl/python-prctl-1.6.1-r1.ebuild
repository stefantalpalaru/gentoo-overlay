# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Control process attributes through prctl"
HOMEPAGE="https://github.com/seveas/python-prctl"
SRC_URI="https://github.com/seveas/${PN}/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-libs/libcap"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	mv *-${PN}-* "${S}"
}
