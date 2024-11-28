# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 flag-o-matic

DESCRIPTION="Collection of python tools for astronomy"
HOMEPAGE="https://www.astro.rug.nl/software/kapteyn/"
SRC_URI="http://cjj.kr.distfiles.macports.org/py-kapteyn/${P}.tar.gz"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

DEPEND="
	sci-astronomy/wcslib
	dev-python/numpy:python2[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	dev-python/astropy[${PYTHON_USEDEP}]
	dev-python/matplotlib:python2[${PYTHON_USEDEP}]
	!<sci-astronomy/kapteyn-2.3.1-r200[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/cython
"

DOCS=( CHANGES.txt README.txt )

PATCHES=(
	"${FILESDIR}"/${PN}-2.3.1-debundle_wcs-r1.patch
)

python_prepare_all() {
	rm -r src/wcslib-4.* || die
	append-cflags "-fpermissive"

	distutils-r1_python_prepare_all
}
