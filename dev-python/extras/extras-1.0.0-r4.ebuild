# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Useful extra bits for Python that should be in the standard library"
HOMEPAGE="https://github.com/testing-cabal/extras/
		https://pypi.org/project/extras/"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 s390 sparc x86"
IUSE="test"
RESTRICT="mirror !test? ( test )"

BDEPEND="
	test? ( dev-python/testtools[${PYTHON_USEDEP}] )"
RDEPEND="
	!<dev-python/extras-1.0.0-r3[${PYTHON_USEDEP}]
"

python_test() {
	"${EPYTHON}" ${PN}/tests/test_extras.py || die
}
