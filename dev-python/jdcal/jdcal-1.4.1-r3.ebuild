# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Julian dates from proleptic Gregorian and Julian calendars"
HOMEPAGE="https://github.com/phn/jdcal"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
SLOT="python2"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"
RDEPEND="
	!<dev-python/jdcal-1.4.1-r3[${PYTHON_USEDEP}]
"

python_test() {
	pytest -vv || die
}
