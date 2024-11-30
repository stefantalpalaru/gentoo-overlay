# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Client library for Rackspace Cloud Monitoring"
HOMEPAGE="https://github.com/racker/rackspace-monitoring"

LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="test"  # resrticted for bug 636106

TEST_DEPENDS="dev-python/pep8[${PYTHON_USEDEP}]"
RDEPEND="
	>=dev-python/apache-libcloud-0.17.0:python2[${PYTHON_USEDEP}]
	<dev-python/apache-libcloud-2.0:python2[${PYTHON_USEDEP}]
	!<dev-python/rackspace-monitoring-0.8.1-r200[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${TEST_DEPENDS}
		${RDEPEND}
	)
"

python_test() {
	${EPYTHON} setup.py test || die
}
