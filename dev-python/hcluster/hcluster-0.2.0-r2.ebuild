# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python hierarchical clustering package for Scipy"
HOMEPAGE="https://pypi.org/project/hcluster/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/numpy-python2[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	dev-python/matplotlib-python2[${PYTHON_USEDEP}]"

# Tests need X display with matplotlib.
RESTRICT="test"
