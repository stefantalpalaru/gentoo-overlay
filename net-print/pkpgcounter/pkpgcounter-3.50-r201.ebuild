# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Generic PDL (Page Description Language) parser in Python"
HOMEPAGE="http://www.pykota.com/software/pkpgcounter"
SRC_URI="http://www.pykota.com/software/${PN}/download/tarballs/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

DEPEND="dev-python/pillow:python2[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	!<net-print/pkpgcounter-3.50-r200[${PYTHON_USEDEP}]
"

src_install() {
	distutils-r1_src_install

	rm -r "${ED}/usr/share/doc/${PN}" || die
}
