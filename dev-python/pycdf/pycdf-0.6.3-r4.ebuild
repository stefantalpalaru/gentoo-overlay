# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_P="${PN}-${PV:0:3}-${PV:4:1}"

DESCRIPTION="Python interface to scientific netCDF library"
HOMEPAGE="http://pysclint.sourceforge.net/pycdf/"
SRC_URI="https://downloads.sourceforge.net/pysclint/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"
LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

DEPEND="dev-python/numpy-python2[${PYTHON_USEDEP}]
	>=sci-libs/netcdf-3.6.1"
RDEPEND="${DEPEND}"

python_install_all() {
	use doc && dodoc doc/pycdf.html
	dodoc CHANGES doc/pycdf.txt
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
