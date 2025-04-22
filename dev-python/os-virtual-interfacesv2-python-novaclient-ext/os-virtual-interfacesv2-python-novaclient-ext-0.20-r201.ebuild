# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_PN="${PN//-/_}"

inherit distutils-r1 pypi

DESCRIPTION="Adds Virtual Interfaces support to python-novaclient"
HOMEPAGE="https://github.com/cerberus98/os_virtual_interfacesv2_ext"
S="${WORKDIR}/os_virtual_interfacesv2_python_novaclient_ext-${PV}"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=">=dev-python/python-novaclient-3.4.0[${PYTHON_USEDEP}]
	!<dev-python/os-virtual-interfacesv2-python-novaclient-ext-0.20-r200[${PYTHON_USEDEP}]
"
