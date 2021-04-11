# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Traceback fiddling library for Python"
HOMEPAGE="https://github.com/ionelmc/python-tblib"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~arm64 ~ia64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
RESTRICT="test"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]
	!<dev-python/tblib-1.6.0-r200[${PYTHON_USEDEP}]
"
