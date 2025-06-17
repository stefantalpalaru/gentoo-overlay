# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
MY_PN=zope.component
MY_P=${MY_PN}-${PV}
PYPI_NO_NORMALIZE=1
PYPI_PN="${MY_PN}"

inherit distutils-r1 pypi

DESCRIPTION="Zope Component Architecture"
HOMEPAGE="https://github.com/zopefoundation/zope.component
	https://docs.zope.org/zope.component/"
S=${WORKDIR}/${MY_P}
LICENSE="ZPL"
SLOT="python2"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"
IUSE="test"
RESTRICT="mirror test"

RDEPEND="
	dev-python/zope-event:python2[${PYTHON_USEDEP}]
	>=dev-python/zope-interface-4.1.0:python2[${PYTHON_USEDEP}]
	!<dev-python/zope-component-4.4.1-r200[${PYTHON_USEDEP}]
"
DEPEND="test? ( ${RDEPEND}
	dev-python/nose[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	nosetests || die
}

python_install_all() {
	distutils-r1_python_install_all

	find "${D}" -name '*.pth' -delete || die
}
