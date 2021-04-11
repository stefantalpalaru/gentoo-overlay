# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Utilities for writing pandoc filters in python"
HOMEPAGE="https://github.com/jgm/pandocfilters"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	!<dev-python/pandocfilters-1.4.2-r200[${PYTHON_USEDEP}]
"
