# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Collection of python tools for astronomy"
HOMEPAGE="https://www.astro.rug.nl/software/kapteyn/"
SRC_URI="http://cjj.kr.distfiles.macports.org/py-kapteyn/${P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	sci-astronomy/wcslib
	dev-python/numpy-python2[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	dev-python/astropy[${PYTHON_USEDEP}]
	dev-python/matplotlib-python2[${PYTHON_USEDEP}]
	!<sci-astronomy/kapteyn-2.3.1-r200[${PYTHON_USEDEP}]
"

DOCS=( CHANGES.txt README.txt )

PATCHES=( "${FILESDIR}"/${PN}-2.3.1-debundle_wcs.patch )

python_prepare_all() {
	rm -r src/wcslib-4.* || die
	distutils-r1_python_prepare_all
}
