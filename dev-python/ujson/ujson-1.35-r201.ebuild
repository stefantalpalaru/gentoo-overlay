# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
DISTUTILS_EXT=1

inherit distutils-r1 pypi

DESCRIPTION="Ultra fast JSON encoder and decoder for Python"
HOMEPAGE="https://pypi.org/project/ujson/"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="mirror !test? ( test )"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/unittest2[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	!<dev-python/ujson-1.35-r200[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/${P}-sort_keys-segfault.patch"
	"${FILESDIR}/${P}-use-static-where-possible.patch"
	"${FILESDIR}/${P}-fix-for-overflowing-long.patch"
	"${FILESDIR}/${P}-standard-handling-of-none.patch"
	"${FILESDIR}/${P}-fix-ordering-of-orderdict.patch"
	"${FILESDIR}/${P}-test-depricationwarning.patch"
)

python_test() {
	"${PYTHON}" tests/tests.py || die
}
