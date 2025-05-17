# Copyright 2017-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Python Lex & Yacc"
HOMEPAGE="https://github.com/etingof/pysmi"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 ~arm ppc ~sparc x86"
RESTRICT="mirror test"

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
