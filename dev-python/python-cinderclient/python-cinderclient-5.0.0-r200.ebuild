# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A client for the OpenStack Cinder API"
HOMEPAGE="https://launchpad.net/python-cinderclient
		https://github.com/openstack/python-cinderclient"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"
IUSE=""
RESTRICT="test"

CDEPEND=">=dev-python/pbr-2.0.0:python2[${PYTHON_USEDEP}]
	!~dev-python/pbr-2.1.0:python2"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}"
RDEPEND="
	${CDEPEND}
	>=dev-python/prettytable-0.7.1[${PYTHON_USEDEP}]
	<dev-python/prettytable-0.8[${PYTHON_USEDEP}]
	>=dev-python/keystoneauth-3.4.0[${PYTHON_USEDEP}]
	>=dev-python/simplejson-3.5.1[${PYTHON_USEDEP}]
	>=dev-python/Babel-2.3.4[${PYTHON_USEDEP}]
	!~dev-python/Babel-2.4.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-3.15.3[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.33.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.14.2[${PYTHON_USEDEP}]
	!~dev-python/requests-2.20.0[${PYTHON_USEDEP}]
	!<dev-python/python-cinderclient-5.0.0-r200[${PYTHON_USEDEP}]
"

src_prepare() {
	sed -i '/^hacking/d' test-requirements.txt || die
	sed -i \
		-e 's/cinder = cinderclient.shell:main/cinder_py2 = cinderclient.shell:main/' \
		setup.cfg || die
	distutils-r1_python_prepare_all
}
