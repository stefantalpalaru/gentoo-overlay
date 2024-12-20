# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="python2-biggles"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A Python module for creating publication-quality 2D scientific plots"
HOMEPAGE="http://biggles.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/biggles/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"
DEPEND="
	dev-python/numpy:python2[${PYTHON_USEDEP}]
	media-libs/plotutils[X]
	x11-libs/libSM
	x11-libs/libXext"
RDEPEND="${DEPEND}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

python_install_all() {
	distutils-r1_python_install_all

	insinto /usr/share/${PN}/
	doins -r examples
}
