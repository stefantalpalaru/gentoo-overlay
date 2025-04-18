# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

MY_PV="${PV//_p/-}"

DESCRIPTION="A python utility/library to sort imports"
HOMEPAGE="https://pypi.org/project/isort/
		https://github.com/timothycrosley/isort"
SRC_URI="https://github.com/timothycrosley/${PN}/archive/${MY_PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~sparc ~x86"
RESTRICT="mirror test"

RDEPEND="
	dev-python/pipfile[${PYTHON_USEDEP}]
	dev-python/backports-functools-lru-cache[${PYTHON_USEDEP}]
	dev-python/futures[${PYTHON_USEDEP}]
	!<dev-python/isort-4.3.21_p2-r200[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/isort-4.3.21_p1-tests.patch"
)

python_prepare_all() {
	sed -i \
		-e 's/isort = isort.main:main/isort_py2 = isort.main:main/' \
		setup.py || die
	distutils-r1_python_prepare_all
}
