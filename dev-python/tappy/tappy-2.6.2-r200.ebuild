# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

MY_PN=tap.py
DESCRIPTION="Test Anything Protocol (TAP) tools"
HOMEPAGE="https://github.com/python-tap/tappy
		https://pypi.org/project/tap.py/"
SRC_URI="mirror://pypi/${MY_PN::1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
S=${WORKDIR}/${MY_PN}-${PV}

LICENSE="BSD-2"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86"
IUSE="yaml"
RESTRICT="test"

RDEPEND="
	yaml? (
		dev-python/more-itertools[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
	)
	!<dev-python/tappy-2.6.2-r1[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/Babel[${PYTHON_USEDEP}]
"

python_prepare_all() {
	sed -i \
		-e 's/"tappy = tap.main:main", "tap = tap.main:main"/"tappy_py2 = tap.main:main", "tap_py2 = tap.main:main"/' \
		setup.py || die
	distutils-r1_python_prepare_all
}
