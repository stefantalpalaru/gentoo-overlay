# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="A client for the OpenStack APIs"
HOMEPAGE="https://github.com/openstack/python-openstackclient"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"
RESTRICT="test"

CDEPEND=">=dev-python/pbr-2.0.0:python2[${PYTHON_USEDEP}]
	!~dev-python/pbr-2.1.0:python2"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}"
RDEPEND="
	${CDEPEND}
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/babel-2.3.4[${PYTHON_USEDEP}]
	!~dev-python/babel-2.4.0[${PYTHON_USEDEP}]
	>=dev-python/cliff-2.8.0[${PYTHON_USEDEP}]
	!~dev-python/cliff-2.9.0[${PYTHON_USEDEP}]
	>=dev-python/keystoneauth1-3.6.2[${PYTHON_USEDEP}]
	>=dev-python/openstacksdk-0.17.0[${PYTHON_USEDEP}]
	>=dev-python/osc-lib-1.14.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-3.15.3[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.33.0[${PYTHON_USEDEP}]
	>=dev-python/python-glanceclient-2.8.0[${PYTHON_USEDEP}]
	>=dev-python/python-keystoneclient-3.17.0[${PYTHON_USEDEP}]
	>=dev-python/python-novaclient-15.0.0[${PYTHON_USEDEP}]
	>=dev-python/python-cinderclient-3.3.0[${PYTHON_USEDEP}]
	!<dev-python/python-openstackclient-4.0.0-r3[${PYTHON_USEDEP}]
"

python_prepare_all() {
	sed -i \
		-e 's/openstack = openstackclient.shell:main/openstack_py2 = openstackclient.shell:main/' \
		setup.cfg || die
	distutils-r1_python_prepare_all
}
