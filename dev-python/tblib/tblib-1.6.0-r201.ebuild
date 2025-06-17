# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Traceback fiddling library for Python"
HOMEPAGE="https://github.com/ionelmc/python-tblib"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror test"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]
	!<dev-python/tblib-1.6.0-r200[${PYTHON_USEDEP}]
"
