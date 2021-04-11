# Copyright 2017-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="Python Lex & Yacc"
HOMEPAGE="https://github.com/etingof/pysmi"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 ~arm ~ia64 ppc ~sparc x86"
RESTRICT="test"

RDEPEND="dev-python/ply:python2[${PYTHON_USEDEP}]
	!<dev-python/pysmi-0.3.4-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

python_prepare_all() {
	for F in mibdump mibcopy; do
		mv "scripts/${F}.py" "scripts/${F}_py2.py"
	done
	sed -i \
		-e 's/mibdump.py/mibdump_py2.py/' \
		-e 's/mibcopy.py/mibcopy_py2.py/' \
		setup.py || die
	distutils-r1_python_prepare_all
}
