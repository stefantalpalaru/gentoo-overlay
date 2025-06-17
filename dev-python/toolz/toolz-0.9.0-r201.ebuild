# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="List processing tools and functional utilities"
HOMEPAGE="https://pypi.org/project/toolz/"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	!<dev-python/toolz-0.9.0-r200[${PYTHON_USEDEP}]
"
