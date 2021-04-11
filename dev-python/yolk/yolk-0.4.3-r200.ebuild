# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Tool and library for querying PyPI and locally installed Python packages"
HOMEPAGE="https://pypi.org/project/yolk/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="python2"
KEYWORDS="amd64 x86"
IUSE="examples"
RESTRICT="test"

DEPEND="
	dev-python/setuptools:python2[${PYTHON_USEDEP}]
	dev-python/yolk-portage[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}
	!<dev-python/yolk-0.4.3-r200[${PYTHON_USEDEP}]
"

python_install_all() {
	distutils-r1_python_install_all

	if use examples; then
		docinto examples/plugins
		dodoc -r examples/plugins/.
	fi
}
