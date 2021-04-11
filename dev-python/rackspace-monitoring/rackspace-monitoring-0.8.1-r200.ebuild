# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Client library for Rackspace Cloud Monitoring"
HOMEPAGE="https://github.com/racker/rackspace-monitoring"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="test"  # resrticted for bug 636106

TEST_DEPENDS="dev-python/pep8[${PYTHON_USEDEP}]"
RDEPEND="
	>=dev-python/libcloud-0.17.0:python2[${PYTHON_USEDEP}]
	<dev-python/libcloud-2.0:python2[${PYTHON_USEDEP}]
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
