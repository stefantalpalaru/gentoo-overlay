# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1
PYPI_PN=PyChef

inherit distutils-r1 pypi

DESCRIPTION="A Python API for interacting with a Chef server"
HOMEPAGE="https://github.com/coderanger/pychef"
S="${WORKDIR}/PyChef-${PV}"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror !test? ( test )"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/versiontools[${PYTHON_USEDEP}]
		test? ( dev-python/mock[${PYTHON_USEDEP}] )"

python_test() {
	nosetests || die
}
