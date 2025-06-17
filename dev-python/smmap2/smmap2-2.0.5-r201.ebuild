# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="A pure python implementation of a sliding window memory map manager"
HOMEPAGE="
	https://pypi.org/project/smmap2/
	https://github.com/gitpython-developers/smmap"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 arm64 ~x86"
IUSE="test"
RESTRICT="mirror !test? ( test )"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
	)"
RDEPEND="
	!dev-python/smmap[${PYTHON_USEDEP}]
	!<dev-python/smmap2-2.0.5-r200[${PYTHON_USEDEP}]
"

python_test() {
	nosetests -v || die "tests failed under ${EPYTHON}"
}
