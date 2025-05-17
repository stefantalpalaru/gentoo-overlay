# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..14})
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Collection of small Python functions & classes"
HOMEPAGE="https://pypi.org/project/python-utils/"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test"
RESTRICT="mirror !test? ( test )"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}"

python_test() {
	"${PYTHON}" ./test_flakes.py || die "Tests failed under ${EPYTHON}"
}
