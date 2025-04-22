# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
MY_PN="${PN//-/}"
PYPI_PN=${MY_PN}

inherit distutils-r1 pypi

DESCRIPTION="OpenStack Sphinx Extensions and Theme"
HOMEPAGE="https://www.openstack.org/"
S="${WORKDIR}/${MY_PN}-${PV}"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~m68k ~ppc ~ppc64 ~s390 ~sparc x86"
RESTRICT="mirror test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/pbr-1.6[${PYTHON_USEDEP}]
"
RDEPEND="
	>=dev-python/requests-2.14.2[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	!<dev-python/oslo-sphinx-4.18.0-r200[${PYTHON_USEDEP}]
"

python_prepare_all() {
	sed -i '/^hacking/d' test-requirements.txt || die
	distutils-r1_python_prepare_all
}
