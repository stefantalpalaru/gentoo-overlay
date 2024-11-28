# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Python hierarchical clustering package for Scipy"
HOMEPAGE="https://pypi.org/project/hcluster/"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/numpy:python2[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	dev-python/matplotlib:python2[${PYTHON_USEDEP}]"

# Tests need X display with matplotlib.
RESTRICT="test"
