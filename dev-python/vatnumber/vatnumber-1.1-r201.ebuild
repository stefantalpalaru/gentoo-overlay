# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Module to validate VAT numbers"
HOMEPAGE="https://pypi.org/project/vatnumber/"
LICENSE="GPL-3"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
IUSE="test vies"
RESTRICT="!test? ( test )"

RDEPEND="vies? ( dev-python/suds-community:python2[${PYTHON_USEDEP}] )
	!<dev-python/vatnumber-1.1-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/suds-community[${PYTHON_USEDEP}] )"

PATCHES=(
	"${FILESDIR}"/${P}-skiptest.patch
)

python_test() {
	esetup.py test
}

src_install() {
	distutils-r1_src_install
	dodoc COPYRIGHT README CHANGELOG
}
