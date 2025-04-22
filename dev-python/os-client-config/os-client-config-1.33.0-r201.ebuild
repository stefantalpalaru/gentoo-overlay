# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="OpenStack Client Configuation Library"
HOMEPAGE="https://www.openstack.org/"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 ~arm64 x86"
RESTRICT="mirror test"

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
