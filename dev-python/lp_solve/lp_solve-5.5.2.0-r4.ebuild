# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python wrappers for lpsolve linear programming library"
HOMEPAGE="http://lpsolve.sourceforge.net/5.5/Python.htm"
SRC_URI="https://downloads.sourceforge.net/lpsolve/${PN}_${PV}_Python_source.tar.gz"
S="${WORKDIR}/${PN}_5.5/extra/Python/"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples"

RDEPEND="
	dev-python/numpy-python2[${PYTHON_USEDEP}]
	sci-mathematics/lpsolve"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}"/${P}-setup.patch )

python_prepare_all() {
	if use examples; then
		mkdir examples || die
		mv ex*py examples || die
	fi
	distutils-r1_python_prepare_all
}

python_test() {
	"${PYTHON}" lpdemo.py || die
}

python_install_all() {
	dodoc changes
	use doc && dodoc Python.htm
	use examples && local EXAMPLES=( examples/. )

	distutils-r1_python_install_all
}
