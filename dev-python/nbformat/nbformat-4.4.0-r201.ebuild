# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='sqlite'

inherit distutils-r1 pypi

DESCRIPTION="Reference implementation of the Jupyter Notebook format"
HOMEPAGE="https://jupyter.org
		https://github.com/jupyter/nbformat"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 ~arm64 x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/jsonschema-2.4.0:python2[${PYTHON_USEDEP}]
	dev-python/ipython-genutils:python2[${PYTHON_USEDEP}]
	>=dev-python/traitlets-4.1:python2[${PYTHON_USEDEP}]
	dev-python/jupyter-core:python2[${PYTHON_USEDEP}]
	!<dev-python/nbformat-4.4.0-r4[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/numpydoc[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/testpath[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
	"

python_prepare_all() {
	# Prevent un-needed download during build
	if use doc; then
		sed -e "/^    'sphinx.ext.intersphinx',/d" -i docs/conf.py || die
	fi

	mv scripts/jupyter-trust scripts/jupyter-trust_py2

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		emake -C docs html
		HTML_DOCS=( docs/_build/html/. )
	fi
}

python_test() {
	distutils_install_for_testing
	cd "${TEST_DIR}"/lib || die
	pytest -vv nbformat || die
}
