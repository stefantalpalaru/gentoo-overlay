# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Openstack Swift sync/backup utility"
HOMEPAGE="https://github.com/cloudnull/turbolift/wiki"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
# tests are not distributed with the release tarball
RESTRICT="mirror test"

DEPEND="dev-python/setuptools
	test? (
		>=dev-python/mock-1.0[${PYTHON_USEDEP}]
		dev-python/unittest2[${PYTHON_USEDEP}]
	)"

RDEPEND=">=dev-python/prettytable-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/cloudlib-0.5.0[${PYTHON_USEDEP}]"

python_test() {
	${PYTHON} -m unit discover turbolift/tests || die "failed testsuite"
}
