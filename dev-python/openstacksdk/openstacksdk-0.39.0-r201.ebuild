# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="A collection of libraries for building applications to work with OpenStack."
HOMEPAGE="https://github.com/openstack/python-openstacksdk"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 ~arm64 x86"
RESTRICT="test"

CDEPEND=">=dev-python/pbr-2.0.0:python2[${PYTHON_USEDEP}]
	!~dev-python/pbr-2.1.0"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}"
RDEPEND="${CDEPEND}
	>=dev-python/pyyaml-3.12[${PYTHON_USEDEP}]
	>=dev-python/appdirs-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/requestsexceptions-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/jsonpatch-1.16[${PYTHON_USEDEP}]
	!~dev-python/jsonpatch-1.20[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/os-service-types-1.7.0[${PYTHON_USEDEP}]
	>=dev-python/keystoneauth1-3.16.0[${PYTHON_USEDEP}]
	>=dev-python/munch-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/decorator-3.4.0[${PYTHON_USEDEP}]
	>=dev-python/jmespath-0.9.0[${PYTHON_USEDEP}]
	virtual/python-ipaddress[${PYTHON_USEDEP}]
	virtual/python-futures[${PYTHON_USEDEP}]
	>=dev-python/iso8601-0.1.11[${PYTHON_USEDEP}]
	>=dev-python/netifaces-0.10.4[${PYTHON_USEDEP}]
	>=dev-python/dogpile-cache-0.6.2[${PYTHON_USEDEP}]
	>=dev-python/cryptography-2.1.0[${PYTHON_USEDEP}]
	!<dev-python/openstacksdk-0.39.0-r3[${PYTHON_USEDEP}]
"

python_prepare_all() {
	sed -i \
		-e 's/openstack-inventory = openstack.cloud.cmd.inventory:main/openstack-inventory_py2 = openstack.cloud.cmd.inventory:main/' \
		setup.cfg
	distutils-r1_python_prepare_all
}
