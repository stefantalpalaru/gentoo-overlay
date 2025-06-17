# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="wide-unicode(+)"
MY_PN=Unidecode
MY_P=${MY_PN}-${PV}
PYPI_NO_NORMALIZE=1
PYPI_PN="${MY_PN}"

inherit distutils-r1 pypi

DESCRIPTION="Module providing ASCII transliterations of Unicode text"
HOMEPAGE="https://pypi.org/project/Unidecode/
		https://github.com/avian2/unidecode"
S=${WORKDIR}/${MY_P}
LICENSE="GPL-2+"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ppc ppc64 sparc x86"
RESTRICT="mirror"

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
