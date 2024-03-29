# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="OpenStack Client Configuation Library"
HOMEPAGE="https://www.openstack.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""
RESTRICT="test"

CDEPEND=">=dev-python/pbr-1.8.0:python2[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}
"
RDEPEND="
	${CDEPEND}
	>=dev-python/openstacksdk-0.13.0[${PYTHON_USEDEP}]
	!<dev-python/os-client-config-1.33.0-r3[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}"/test_get_all_clouds.patch
)

python_prepare_all() {
	sed -i '/^hacking/d' test-requirements.txt || die
	distutils-r1_python_prepare_all
}
