# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="wide-unicode(+)"

MY_PN=Unidecode
MY_P=${MY_PN}-${PV}

inherit distutils-r1

DESCRIPTION="Module providing ASCII transliterations of Unicode text"
HOMEPAGE="https://pypi.org/project/Unidecode/
		https://github.com/avian2/unidecode"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="GPL-2+"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ppc ppc64 sparc x86"

S=${WORKDIR}/${MY_P}

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	!<dev-python/unidecode-1.1.1-r200[${PYTHON_USEDEP}]
"
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_prepare_all() {
	sed -i \
		-e 's/unidecode = unidecode.util:main/unidecode_py2 = unidecode.util:main/' \
		setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test
}
