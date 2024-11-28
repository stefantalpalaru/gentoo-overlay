# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 pypi

DESCRIPTION="Jupyter Interactive Notebook"
HOMEPAGE="http://jupyter.org
		https://github.com/jupyter/notebook"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64"
IUSE="doc test"
RESTRICT="!test? ( test )"
RDEPEND="
	>=dev-libs/mathjax-2.4
	dev-python/jinja2:python2[${PYTHON_USEDEP}]
	>=dev-python/terminado-0.8.1:python2[${PYTHON_USEDEP}]
	>=dev-python/tornado-4.0:python2[${PYTHON_USEDEP}]
	dev-python/ipython-genutils:python2[${PYTHON_USEDEP}]
	>=dev-python/traitlets-4.2.1:python2[${PYTHON_USEDEP}]
	>=dev-python/jupyter-core-4.4.0:python2[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-17:python2[${PYTHON_USEDEP}]
	>=dev-python/jupyter-client-5.2:python2[${PYTHON_USEDEP}]
	dev-python/nbformat:python2[${PYTHON_USEDEP}]
	>=dev-python/nbconvert-4.2.0:python2[${PYTHON_USEDEP}]
	dev-python/ipykernel:python2[${PYTHON_USEDEP}]
	dev-python/send2trash:python2[${PYTHON_USEDEP}]
	dev-python/prometheus-client:python2[${PYTHON_USEDEP}]
	!<dev-python/notebook-5.7.8-r200[${PYTHON_USEDEP}]
"

# sphinx 2+ seems to have a problem with its github plugin. temporarily adding
# a version constraint.
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/nose-exclude[${PYTHON_USEDEP}]
		dev-python/nose-warnings-filters[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	)
	doc? (
		app-text/pandoc
		dev-python/ipython[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.3.6[${PYTHON_USEDEP}]
		<dev-python/sphinx-2[${PYTHON_USEDEP}]
		dev-python/sphinxcontrib-github-alt[${PYTHON_USEDEP}]
		dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
		dev-python/nbsphinx[${PYTHON_USEDEP}]
		test? (
			dev-python/nbval[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
		)
	)
	"

PATCHES=( "${FILESDIR}/${PN}"-5.7.0-no-mathjax.patch )

# Opens a qtconsole
restrict="doc"

python_prepare_all() {
	sed -i \
		-e "/import setup/s:$:\nimport setuptools:g" \
		-e "s/jupyter-notebook = notebook.notebookapp:main/jupyter-notebook_py2 = notebook.notebookapp:main/" \
		-e "s/jupyter-nbextension = notebook.nbextensions:main/jupyter-nbextension_py2 = notebook.nbextensions:main/" \
		-e "s/jupyter-serverextension = notebook.serverextensions:main/jupyter-serverextension_py2 = notebook.serverextensions:main/" \
		-e "s/jupyter-bundlerextension = notebook.bundler.bundlerextensions:main/jupyter-bundlerextension_py2 = notebook.bundler.bundlerextensions:main/" \
		setup.py || die

	# disable bundled mathjax
	sed -i 's/^.*MathJax.*$//' bower.json || die

	# Prevent un-needed download during build
	if use doc; then
		sed \
			-e "/^    'sphinx.ext.intersphinx',/d" \
			-i docs/source/conf.py || die
	fi

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		addwrite /dev/dri/card0
		emake -C docs html
		HTML_DOCS=( docs/build/html/. )
	fi
}

python_test() {
	nosetests \
		--verbosity=3 \
		--exclude-dir notebook/tests/selenium \
		notebook || die

	# These doc-based tests are broken on gentoo for permission-related errors
	# (they try to write files in system's ipython folder). Disabled for now.
	# if use doc; then
	#	pytest --nbval --current-env docs || die
	# fi
}

python_install() {
	distutils-r1_python_install

	ln -sf \
		"${EPREFIX}/usr/share/mathjax" \
		"${D}$(python_get_sitedir)/notebook/static/components/MathJax" || die
}

pkg_preinst() {
	# remove old mathjax folder if present
	rm -rf "${EROOT}"/usr/lib*/python*/site-packages/notebook/static/components/MathJax || die
}
