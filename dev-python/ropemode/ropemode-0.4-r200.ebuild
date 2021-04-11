# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A helper for using rope refactoring library in IDEs"
HOMEPAGE="https://github.com/python-rope/ropemode
		https://pypi.org/project/ropemode/"
SRC_URI="https://github.com/python-rope/ropemode/archive/${PV}.tar.gz -> ${P}.tar.gz"
# pypi releases don't include tests
#SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-python/rope-0.9.4[${PYTHON_USEDEP}]
	!<dev-python/ropemode-0.4-r200[${PYTHON_USEDEP}]
"
DEPEND="${DEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	"${PYTHON}" ropemodetest.py || die "tests failed with ${EPYTHON}"
}
