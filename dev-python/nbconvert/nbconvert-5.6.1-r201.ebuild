# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Converting Jupyter Notebooks"
HOMEPAGE="https://nbconvert.readthedocs.io/
		https://github.com/jupyter/nbconvert"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"

RDEPEND="
	dev-python/bleach:python2[${PYTHON_USEDEP}]
	dev-python/defusedxml:python2[${PYTHON_USEDEP}]
	>=dev-python/entrypoints-0.2.2:python2[${PYTHON_USEDEP}]
	dev-python/jinja2:python2[${PYTHON_USEDEP}]
	dev-python/jupyter-core:python2[${PYTHON_USEDEP}]
	>=dev-python/mistune-0.8.1:python2[${PYTHON_USEDEP}]
	dev-python/nbformat:python2[${PYTHON_USEDEP}]
	>=dev-python/pandocfilters-1.4.1:python2[${PYTHON_USEDEP}]
	dev-python/pygments:python2[${PYTHON_USEDEP}]
	>=dev-python/traitlets-4.2.1:python2[${PYTHON_USEDEP}]
	dev-python/testpath:python2[${PYTHON_USEDEP}]
	dev-python/tornado:python2[${PYTHON_USEDEP}]
	!<dev-python/nbconvert-5.6.1-r3[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		${RDEPEND}
		dev-python/ipython[${PYTHON_USEDEP}]
		dev-python/jupyter-client[${PYTHON_USEDEP}]
		dev-python/nbsphinx[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
	)
	test? (
		${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/ipykernel[${PYTHON_USEDEP}]
		>=dev-python/jupyter-client-4.2[${PYTHON_USEDEP}]
	)
"

# still failing in many places
RESTRICT=test

python_prepare_all() {
	# Prevent un-needed download during build
	if use doc; then
		sed -e "/^    'sphinx.ext.intersphinx',/d" -i docs/source/conf.py || die
	fi
	sed -i \
		-e 's/jupyter-nbconvert = nbconvert.nbconvertapp:main/jupyter-nbconvert_py2 = nbconvert.nbconvertapp:main/' \
		setup.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		emake -C docs html
		HTML_DOCS=( docs/build/html/. )
	fi
}

python_test() {
	distutils_install_for_testing
	cd "${TEST_DIR}"/lib || die
	pytest -v --pyargs nbconvert || die
}

pkg_postinst() {
	if ! has_version app-text/pandoc ; then
		einfo "Pandoc is required for converting to formats other than Python,"
		einfo "HTML, and Markdown. If you need this functionality, install"
		einfo "app-text/pandoc."
	fi
}
