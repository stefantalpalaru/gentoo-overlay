# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Access cnb.cz daily rates with the comfort of your command line"
HOMEPAGE="https://github.com/yaccz/pycnb"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 x86"

DEPEND="dev-python/cement:python2[${PYTHON_USEDEP}]
	dev-python/twisted-web:python2[${PYTHON_USEDEP}]
	dev-python/setuptools:python2[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	!<dev-python/pycnb-0.0.4-r200[${PYTHON_USEDEP}]
"

src_unpack() {
	default
	chmod -R a+rX,u+w,g-w,o-w ${P} || die
}
