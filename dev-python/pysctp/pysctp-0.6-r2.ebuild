# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
DISTUTILS_EXT=1

inherit distutils-r1

DESCRIPTION="PySCTP gives access to the SCTP transport protocol from Python"
HOMEPAGE="https://github.com/philpraxis/pysctp"
SRC_URI="https://github.com/philpraxis/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror test"

DEPEND="net-misc/lksctp-tools"
RDEPEND="${DEPEND}"

src_install() {
	distutils-r1_src_install
	rm -v "${ED}/usr/_sctp.h"
	dodoc test_local_cnx.py test_remote_cnx.py
}
