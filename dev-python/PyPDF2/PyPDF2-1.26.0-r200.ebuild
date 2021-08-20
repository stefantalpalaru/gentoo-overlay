# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python library to work with pdf files"
HOMEPAGE="https://pypi.org/project/PyPDF2/
	https://github.com/mstamy2/PyPDF2"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="python2"
KEYWORDS="amd64 x86"
IUSE="examples"

RDPEND="
	!<dev-python/PyPDF2-1.26.0-r1[${PYTHON_USEDEP}]
"

PATCHES=( "${FILESDIR}/${P}-py3-tests.patch" )

python_test() {
	"${EPYTHON}" -m unittest Tests.tests || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	if use examples; then
		docinto examples
		dodoc -r Sample_Code/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}
