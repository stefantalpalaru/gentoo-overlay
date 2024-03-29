# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Adds Virtual Interfaces support to python-novaclient"
HOMEPAGE="https://github.com/cerberus98/os_virtual_interfacesv2_ext"
SRC_URI="mirror://pypi/${PN:0:1}/os_virtual_interfacesv2_python_novaclient_ext/os_virtual_interfacesv2_python_novaclient_ext-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/os_virtual_interfacesv2_python_novaclient_ext-${PV}"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=">=dev-python/python-novaclient-3.4.0[${PYTHON_USEDEP}]
	!<dev-python/os-virtual-interfacesv2-python-novaclient-ext-0.20-r200[${PYTHON_USEDEP}]
"
