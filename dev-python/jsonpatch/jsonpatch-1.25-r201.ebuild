# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Apply JSON-Patches like http://tools.ietf.org/html/draft-pbryan-json-patch-04"
HOMEPAGE="https://github.com/stefankoegl/python-json-patch"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 ~arm64 ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="mirror test"

RDEPEND=">=dev-python/jsonpointer-1.9:python2[${PYTHON_USEDEP}]
	!<dev-python/jsonpatch-1.25-r200[${PYTHON_USEDEP}]
"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND} )"

python_prepare_all() {
	for F in bin/*; do
		mv "${F}" "${F}_py2"
	done
	sed -i \
		-e "s#scripts=\['bin/jsondiff', 'bin/jsonpatch'\]#scripts=\['bin/jsondiff_py2', 'bin/jsonpatch_py2'\]#" \
		setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	"${PYTHON}" tests.py || die "Tests of tests.py fail with ${EPYTHON}"
	"${PYTHON}" ext_tests.py || die "Tests of ext_tests.py fail with ${EPYTHON}"
}
