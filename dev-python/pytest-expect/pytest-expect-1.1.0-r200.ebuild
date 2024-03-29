# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="py.test plugin that stores test expectations by saving the set of failing tests"
HOMEPAGE="https://github.com/gsnedders/pytest-expect/
		https://pypi.org/project/pytest-expect/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 s390 sparc x86"
IUSE=""

RDEPEND="
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/u-msgpack[${PYTHON_USEDEP}]
	!<dev-python/pytest-expect-1.1.0-r200[${PYTHON_USEDEP}]
"

# no tests...
RESTRICT="test"
