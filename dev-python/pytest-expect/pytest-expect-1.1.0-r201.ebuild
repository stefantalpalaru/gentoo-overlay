# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="py.test plugin that stores test expectations by saving the set of failing tests"
HOMEPAGE="https://github.com/gsnedders/pytest-expect/
		https://pypi.org/project/pytest-expect/"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~mips ppc ppc64 s390 sparc x86"

RDEPEND="
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/u-msgpack-python[${PYTHON_USEDEP}]
	!<dev-python/pytest-expect-1.1.0-r200[${PYTHON_USEDEP}]
"

# no tests...
RESTRICT="test"
