# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Command Line Utility for Rackspace Cloud Monitoring (MaaS)"
HOMEPAGE="https://github.com/racker/rackspace-monitoring-cli"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
# https://github.com/racker/rackspace-monitoring-cli/issues/49
RESTRICT="mirror test"

TEST_DEPENDS="dev-python/pep8[${PYTHON_USEDEP}]"
RDEPEND=">=dev-python/rackspace-monitoring-0.6.5[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		test? ( ${TEST_DEPENDS} )"

python_test() {
	${EPYTHON} setup.py pep8 || die
}
