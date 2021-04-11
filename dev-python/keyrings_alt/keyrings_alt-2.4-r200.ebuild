# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="${PN/_/.}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Alternate keyring implementations"
HOMEPAGE="https://github.com/jaraco/keyrings.alt
	https://pypi.org/project/keyrings.alt/"
SRC_URI="mirror://pypi/${P:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="dev-python/six:python2[${PYTHON_USEDEP}]
	!<dev-python/keyrings_alt-2.4-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm-1.15.0:python2[${PYTHON_USEDEP}]
"

S=${WORKDIR}/${MY_P}

python_prepare_all() {
	sed \
		-e "s:find_packages():find_packages(exclude=['tests']):g" \
		-i setup.py || die
	distutils-r1_python_prepare_all
}
