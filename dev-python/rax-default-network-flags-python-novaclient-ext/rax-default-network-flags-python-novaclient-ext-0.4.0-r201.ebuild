# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_PN="${PN//-/_}"

inherit distutils-r1 pypi

DESCRIPTION="Disk Config extension for python-novaclient"
HOMEPAGE="https://github.com/rackerlabs/rax_default_network_flags_python_novaclient_ext"
S="${WORKDIR}/rax_default_network_flags_python_novaclient_ext-${PV}"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=">=dev-python/python-novaclient-2.20.0[${PYTHON_USEDEP}]
	!<dev-python/rax-default-network-flags-python-novaclient-ext-0.4.0-r200[${PYTHON_USEDEP}]
"
