# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="A client for the OpenStack Nova API"
HOMEPAGE="https://github.com/rackerlabs/rackspace-novaclient"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	>=dev-python/python-novaclient-2.17.0[${PYTHON_USEDEP}]
	>=dev-python/rackspace-auth-openstack-1.3[${PYTHON_USEDEP}]
	>=dev-python/os-diskconfig-python-novaclient-ext-0.1.2[${PYTHON_USEDEP}]
	!dev-python/rax-backup-schedule-python-novaclient-ext[${PYTHON_USEDEP}]
	>=dev-python/os-networksv2-python-novaclient-ext-0.21[${PYTHON_USEDEP}]
	>=dev-python/os-virtual-interfacesv2-python-novaclient-ext-0.15[${PYTHON_USEDEP}]
	>=dev-python/rax-default-network-flags-python-novaclient-ext-0.2.4[${PYTHON_USEDEP}]
	dev-python/ip-associations-python-novaclient-ext[${PYTHON_USEDEP}]
	!<dev-python/rackspace-novaclient-2.1-r200[${PYTHON_USEDEP}]
"

python_prepare() {
	mkdir -p "${BUILD_DIR}" || die
}
