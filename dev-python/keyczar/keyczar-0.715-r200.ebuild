# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )	#appears py2 friendly only
DISTUTILS_USE_SETUPTOOLS=manual

inherit distutils-r1

MY_PN=python-${PN}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Toolkit for safe and simple cryptography"
HOMEPAGE="http://www.keyczar.org https://pypi.org/project/python-keyczar/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 x86"
IUSE="doc"

DEPEND="dev-python/setuptools:python2[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	>=dev-python/pycrypto-2.0[${PYTHON_USEDEP}]
	dev-python/pyasn1[${PYTHON_USEDEP}]
	!<dev-python/keyczar-0.715-r200[${PYTHON_USEDEP}]
"

S=${WORKDIR}/${MY_P}

python_test() {
	cd tests/keyczar_tests
	${PYTHON} alltests.py || die "tests fail with ${EPYTHON}"
}

python_install_all() {
	use doc && dodoc doc/pycrypt*

	distutils-r1_python_install_all
}
