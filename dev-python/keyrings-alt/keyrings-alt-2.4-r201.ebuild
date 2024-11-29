# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
MY_PN="${PN/-/.}"
MY_P="${MY_PN}-${PV}"
PYPI_PN="${MY_PN}"
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Alternate keyring implementations"
HOMEPAGE="https://github.com/jaraco/keyrings.alt
	https://pypi.org/project/keyrings.alt/"
S=${WORKDIR}/${MY_P}
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
RESTRICT="test"

RDEPEND="dev-python/six:python2[${PYTHON_USEDEP}]
	!<dev-python/keyrings-alt-2.4-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/setuptools-scm-1.15.0:python2[${PYTHON_USEDEP}]
"

python_prepare_all() {
	sed \
		-e "s:find_packages():find_packages(exclude=['tests']):g" \
		-i setup.py || die
	distutils-r1_python_prepare_all
}
