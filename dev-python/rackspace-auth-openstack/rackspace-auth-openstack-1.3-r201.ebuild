# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Rackspace Auth Plugin for OpenStack Clients"
HOMEPAGE="https://github.com/emonty/rackspace-auth-openstack"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	!<dev-python/rackspace-auth-openstack-1.3-r200[${PYTHON_USEDEP}]
"
