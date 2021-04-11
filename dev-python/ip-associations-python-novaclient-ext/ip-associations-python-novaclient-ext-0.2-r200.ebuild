# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Disk Config extension for python-novaclient"
HOMEPAGE="https://github.com/rackerlabs/ip_associations_python_novaclient_ext"
SRC_URI="mirror://pypi/${PN:0:1}/ip_associations_python_novaclient_ext/ip_associations_python_novaclient_ext-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/ip_associations_python_novaclient_ext-${PV}"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=">=dev-python/python-novaclient-2.20.0[${PYTHON_USEDEP}]
	!<dev-python/ip-associations-python-novaclient-ext-0.2-r200[${PYTHON_USEDEP}]
"
