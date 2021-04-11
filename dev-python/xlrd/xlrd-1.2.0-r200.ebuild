# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Library to extract data from Microsoft Excel spreadsheets"
HOMEPAGE="http://www.python-excel.org/
			https://github.com/python-excel/xlrd"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"
RESTRICT="test"

RDEPEND="
	!<dev-python/xlrd-1.2.0-r200[${PYTHON_USEDEP}]
"

python_prepare_all() {
	# Remove this if examples get reintroduced
	sed -i -e "s/test_names_demo/_&/" tests/test_open_workbook.py || die
	mv scripts/runxlrd.py scripts/runxlrd_py2.py || die
	sed -i \
		-e 's#scripts/runxlrd.py#scripts/runxlrd_py2.py#' \
		setup.py || die
	distutils-r1_python_prepare_all
}
