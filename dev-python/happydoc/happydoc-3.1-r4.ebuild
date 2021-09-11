# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="HappyDoc"
MY_PV=$(ver_rs 1- "_" ${PV})
MY_V=$(ver_cut 1 ${PV})

DESCRIPTION="Tool for extracting documentation from Python source code"
HOMEPAGE="http://happydoc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}_r${MY_PV}.tar.gz"

LICENSE="HPND ZPL"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc sparc x86"
IUSE="doc"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

# Tests need extra data not present in the release tarball.
RESTRICT="test"

S="${WORKDIR}/${MY_PN}${MY_V}-r${MY_PV}"

python_prepare_all() {
	cp "${FILESDIR}/${P}-setup.py" setup.py || die "Copying of setup.py failed"
	patch -p0 "${FILESDIR}/${P}-python-2.6.patch" || die
	distutils-r1_python_prepare_all
}

python_install_all() {
	use doc && local HTML_DOCS=( srcdocs/${MY_PN}${MY_V}-r${MY_PV}/. )
	distutils-r1_python_install_all
}
