# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="DBUtils"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Database connections for multi-threaded environments"
HOMEPAGE="https://cito.github.io/DBUtils/
	https://github.com/Cito/DBUtils
	https://pypi.org/project/DBUtils/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"
LICENSE="OSL-2.0"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="doc examples"
RESTRICT="mirror test"

python_prepare_all() {
	sed -i -e "s/, 'DBUtils.Tests'//" \
		-e "s/, 'DBUtils.Examples'//" \
		-e "/package_data=/d" \
		setup.py || die "sed failed"
	distutils-r1_python_prepare_all
}

python_test() {
	nosetests -s ${MY_PN}/Tests
}

python_install_all() {
	use doc && local HTML_DOCS=( "${S}/${MY_PN}"/Docs/. )
	use examples && local EXAMPLES=( "${MY_PN}"/Examples/. )
	distutils-r1_python_install_all
}
