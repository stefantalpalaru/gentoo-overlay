# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Read/rewrite/write Python ASTs"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"
HOMEPAGE="https://pypi.org/project/astor/"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="!<dev-python/astor-0.8.0-r3[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}/astor-setuptools.patch"
)

python_prepare_all() {
	#avoid file collisions picked up by the eclass
	sed -e s":find_packages():find_packages(exclude=['tests']):" -i setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	"${PYTHON}" -m unittest discover || die "tests failed under ${EPYTHON}"
}
