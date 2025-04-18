# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"
PYPI_PN="${PN^}"
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Python documentation generator"
HOMEPAGE="http://www.sphinx-doc.org/"
S="${WORKDIR}/${P^}"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="doc latex net test"

# Tests automagically use latex, bug 667414
#REQUIRED_USE="test? ( latex )"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/alabaster-0.7.9:python2[${PYTHON_USEDEP}]
	<dev-python/alabaster-0.8:python2[${PYTHON_USEDEP}]
	>=dev-python/babel-2.1.1:python2[${PYTHON_USEDEP}]
	>=dev-python/docutils-0.11:python2[${PYTHON_USEDEP}]
	dev-python/imagesize:python2[${PYTHON_USEDEP}]
	>=dev-python/jinja2-2.3:python2[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.0.1-r1:python2[${PYTHON_USEDEP}]
	>=dev-python/requests-2.0.0:python2[${PYTHON_USEDEP}]
	>=dev-python/six-1.5:python2[${PYTHON_USEDEP}]
	>=dev-python/snowballstemmer-1.1:python2[${PYTHON_USEDEP}]
	>=dev-python/sphinx-rtd-theme-0.1:python2[${PYTHON_USEDEP}]
	<dev-python/sphinx-rtd-theme-2.0:python2[${PYTHON_USEDEP}]
	dev-python/packaging:python2[${PYTHON_USEDEP}]
	dev-python/sphinxcontrib-websupport:python2[${PYTHON_USEDEP}]
	virtual/python-typing[${PYTHON_USEDEP}]
	latex? (
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-luatex
		app-text/dvipng
	)
	net? (
		>=dev-python/sqlalchemy-0.9:python2[${PYTHON_USEDEP}]
		>=dev-python/whoosh-2.0:python2[${PYTHON_USEDEP}]
	)
	!<dev-python/sphinx-1.8.5-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/sphinxcontrib-websupport[${PYTHON_USEDEP}]
		dev-python/html5lib[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/simplejson[${PYTHON_USEDEP}]
		>=dev-python/sqlalchemy-0.9[${PYTHON_USEDEP}]
		>=dev-python/whoosh-2.0[${PYTHON_USEDEP}]
		virtual/imagemagick-tools[jpeg,png,svg]
		virtual/python-enum34[${PYTHON_USEDEP}]
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-luatex
		app-text/dvipng
	)"

python_prepare_all() {
	# remove tests that fail due to network-sandbox
	rm tests/test_websupport.py || die "Failed to remove web tests"
	rm tests/test_build_linkcheck.py || die "Failed to remove web tests"
	sed -i -e 's:test_latex_remote_images:_&:' tests/test_build_latex.py || die

	# fails when additional sphinx themes are installed
	sed -i -e 's:test_theme_api:_&:' tests/test_theming.py || die

	sed -i \
		-e 's/sphinx-build = sphinx.cmd.build:main/sphinx-build_py2 = sphinx.cmd.build:main/' \
		-e 's/sphinx-quickstart = sphinx.cmd.quickstart:main/sphinx-quickstart_py2 = sphinx.cmd.quickstart:main/' \
		-e 's/sphinx-apidoc = sphinx.ext.apidoc:main/sphinx-apidoc_py2 = sphinx.ext.apidoc:main/' \
		-e 's/sphinx-autogen = sphinx.ext.autosummary.generate:main/sphinx-autogen_py2 = sphinx.ext.autosummary.generate:main/' \
		setup.py || die

	distutils-r1_python_prepare_all
}

python_compile() {
	distutils-r1_python_compile

	# Generate the grammar. It will be caught by install somehow.
	# Note that the tests usually do it for us. However, I don't want
	# to trust USE=test really running all the tests, especially
	# with FEATURES=test-fail-continue.
	pushd "${BUILD_DIR}"/lib >/dev/null || die
	"${EPYTHON}" -m sphinx.pycode.__init__ || die "Grammar generation failed."
	popd >/dev/null || die
}

python_compile_all() {
	if use doc; then
		esetup.py build_sphinx
		HTML_DOCS=( "${BUILD_DIR}"/sphinx/html/. )
	fi
}

python_test() {
	mkdir -p "${BUILD_DIR}/sphinx_tempdir" || die
	local -x SPHINX_TEST_TEMPDIR="${BUILD_DIR}/sphinx_tempdir"
	py.test -vv || die "Tests fail with ${EPYTHON}"
}
