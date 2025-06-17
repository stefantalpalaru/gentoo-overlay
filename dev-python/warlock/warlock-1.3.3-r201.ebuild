# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Python object model built on JSON schema and JSON patch"
HOMEPAGE="https://github.com/bcwaldon/warlock"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="mirror !test? ( test )"

CDEPEND="
		>=dev-python/jsonpatch-0.10:python2[${PYTHON_USEDEP}]
		<dev-python/jsonpatch-2:python2[${PYTHON_USEDEP}]
		>=dev-python/jsonschema-0.7:python2[${PYTHON_USEDEP}]
		<dev-python/jsonschema-4:python2[${PYTHON_USEDEP}]
"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		test? ( dev-python/six:python2[${PYTHON_USEDEP}]
			${CDEPEND}
		)
		!<dev-python/warlock-1.3.3-r200[${PYTHON_USEDEP}]
"
RDEPEND="dev-python/six[${PYTHON_USEDEP}]
		${CDEPEND}
"

python_test() {
	"${PYTHON}" test/test_core.py || die
}
