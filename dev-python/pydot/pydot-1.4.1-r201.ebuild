# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python interface to Graphviz's Dot language"
HOMEPAGE="https://github.com/erocarrera/pydot
		https://pypi.org/project/pydot/"
# pypi releases don't include tests
SRC_URI="https://github.com/erocarrera/pydot/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ~mips ppc ppc64 s390 ~sparc x86 ~amd64-linux ~ppc-macos ~x64-macos"
IUSE="test"
RESTRICT="mirror !test? ( test )"

RDEPEND="
	>=dev-python/pyparsing-2.1.4:python2[${PYTHON_USEDEP}]
	media-gfx/graphviz
	!<dev-python/pydot-1.4.1-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/chardet[${PYTHON_USEDEP}] )"

python_test() {
	cd test || die
	"${PYTHON}" pydot_unittest.py || die "Test failed with ${EPYTHON}"
}
