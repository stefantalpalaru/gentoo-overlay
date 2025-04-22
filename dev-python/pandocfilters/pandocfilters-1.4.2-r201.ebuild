# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Utilities for writing pandoc filters in python"
HOMEPAGE="https://github.com/jgm/pandocfilters"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror"

RDEPEND="
	!<dev-python/pandocfilters-1.4.2-r200[${PYTHON_USEDEP}]
"
