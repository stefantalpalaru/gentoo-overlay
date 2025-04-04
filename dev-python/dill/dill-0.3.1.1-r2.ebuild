# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Serialize all of python (almost)"
HOMEPAGE="https://pypi.org/project/dill/"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~arm64 ~ppc ~x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror"

RDEPEND="
	!<dev-python/dill-0.3.1.1-r1[${PYTHON_USEDEP}]
"

python_prepare_all() {
	mv scripts/get_objgraph scripts/get_objgraph_py2
	mv scripts/undill scripts/undill_py2
	sed -i \
		-e "s%scripts=\['scripts/undill','scripts/get_objgraph'\]%scripts=['scripts/undill_py2','scripts/get_objgraph_py2']%" \
		setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	local fail= t
	for t in tests/test_*.py; do
		ebegin "\t${t}"
		"${EPYTHON}" "${t}"
		eend "\t${t}" || fail=1
	done

	[[ ${fail} ]] && die "Tests fail with ${EPYTHON}"
}
