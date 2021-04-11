# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DOCS=( README.rst CHANGES.md )

DESCRIPTION="pytest plugin to facilitate comparison of arrays"
HOMEPAGE="https://github.com/astrofrog/pytest-arraydiff/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""
RESTRICT="test"

RDEPEND="
	dev-python/numpy-python2[${PYTHON_USEDEP}]
	dev-python/pytest:python2[${PYTHON_USEDEP}]
	dev-python/six:python2[${PYTHON_USEDEP}]
	!<dev-python/pytest-arraydiff-0.1-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
