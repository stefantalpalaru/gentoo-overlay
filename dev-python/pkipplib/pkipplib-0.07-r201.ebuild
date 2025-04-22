# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Pkipplib is a Python module which parses IPP requests"
HOMEPAGE="http://www.pykota.com/software/pkipplib/"
SRC_URI="http://www.pykota.com/software/pkipplib/download/tarballs/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

RDEPEND="
	!<dev-python/pkipplib-0.07-r200[${PYTHON_USEDEP}]
"
