# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Platform for Python test doubles: mocks, stubs, fakes, and dummies"
HOMEPAGE="http://labix.org/mocker https://pypi.org/project/mocker/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.bz2"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc64 x86 ~amd64-linux ~x86-linux ~x64-macos"
RESTRICT="mirror"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}"/${P}-pypy_test.patch )

python_test() {
	"${PYTHON}" test.py || die "Tests failed under ${EPYTHON}"
}
