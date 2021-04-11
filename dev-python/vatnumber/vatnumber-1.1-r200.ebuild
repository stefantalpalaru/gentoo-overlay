# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Module to validate VAT numbers"
HOMEPAGE="https://pypi.org/project/vatnumber/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
IUSE="test vies"

RDEPEND="vies? ( dev-python/suds:python2[${PYTHON_USEDEP}] )
	!<dev-python/vatnumber-1.1-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/suds[${PYTHON_USEDEP}] )"

PATCHES=( "${FILESDIR}"/${P}-skiptest.patch )

python_test() {
	esetup.py test
}

src_install() {
	distutils-r1_src_install
	dodoc COPYRIGHT README CHANGELOG
}
