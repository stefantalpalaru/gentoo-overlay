# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )	#appears py2 friendly only
DISTUTILS_USE_SETUPTOOLS=manual
MY_PN=python-${PN}
MY_P=${MY_PN}-${PV}
PYPI_NO_NORMALIZE=1
PYPI_PN="${MY_PN}"

inherit distutils-r1 pypi

DESCRIPTION="Toolkit for safe and simple cryptography"
HOMEPAGE="http://www.keyczar.org
		https://pypi.org/project/python-keyczar/"
S=${WORKDIR}/${MY_P}
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ppc ~ppc64 x86"
IUSE="doc"
RESTRICT="mirror"

DEPEND="dev-python/setuptools:python2[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	>=dev-python/pycrypto-2.0[${PYTHON_USEDEP}]
	dev-python/pyasn1[${PYTHON_USEDEP}]
	!<dev-python/keyczar-0.715-r200[${PYTHON_USEDEP}]
"

python_test() {
	cd tests/keyczar_tests
	${PYTHON} alltests.py || die "tests fail with ${EPYTHON}"
}

python_install_all() {
	use doc && dodoc doc/pycrypt*

	distutils-r1_python_install_all
}
