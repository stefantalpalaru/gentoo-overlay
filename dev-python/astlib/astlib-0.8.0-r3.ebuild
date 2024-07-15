# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 flag-o-matic

MYPN=astLib
MYP=${MYPN}-${PV}

DESCRIPTION="Python astronomy modules for image and coordinate manipulation"
HOMEPAGE="http://astlib.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${MYP}.tar.gz"
S="${WORKDIR}/${MYP}"
LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples"

PATCHES=( "${FILESDIR}/${P}-system-wcstools.patch" )

DEPEND="sci-astronomy/wcstools"
RDEPEND="${DEPEND}
	dev-python/astropy[${PYTHON_USEDEP}]
	dev-python/matplotlib-python2[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/scipy-python2[${PYTHON_USEDEP}]"

python_prepare_all() {
	append-cflags -fpermissive
	distutils-r1_python_prepare_all
}

python_install_all() {
	dodoc CHANGE_LOG RELEASE_NOTES
	docinto /usr/share/doc/${PF}/html
	use doc && dodoc -r docs/${MYPN}/*
	docinto /usr/share/doc/${PF}
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}
