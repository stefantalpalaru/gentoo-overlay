# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='readline,sqlite,threads(+)'

inherit distutils-r1 optfeature pypi virtualx

DESCRIPTION="Advanced interactive shell for Python"
HOMEPAGE="http://ipython.org/"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples matplotlib notebook nbconvert qt5 +smp test wxwidgets"
RESTRICT="!test? ( test )"

CDEPEND="
	dev-python/decorator:python2[${PYTHON_USEDEP}]
	>=dev-python/jedi-0.10.0:python2[${PYTHON_USEDEP}]
	dev-python/pexpect:python2[${PYTHON_USEDEP}]
	dev-python/pickleshare:python2[${PYTHON_USEDEP}]
	>=dev-python/prompt-toolkit-1.0.4:python2[${PYTHON_USEDEP}]
	<dev-python/prompt-toolkit-2.0.0:python2[${PYTHON_USEDEP}]
	dev-python/pyparsing:python2[${PYTHON_USEDEP}]
	dev-python/simplegeneric:python2[${PYTHON_USEDEP}]
	>=dev-python/traitlets-4.2.1:python2[${PYTHON_USEDEP}]
	matplotlib? (
		dev-python/matplotlib:python2[${PYTHON_USEDEP}]
	)
	wxwidgets? ( dev-python/wxpython:*[${PYTHON_USEDEP}] )
"

RDEPEND="${CDEPEND}
	virtual/python-pathlib[${PYTHON_USEDEP}]
	nbconvert? ( dev-python/nbconvert[${PYTHON_USEDEP}] )
	!<dev-python/ipython-5.9.0-r4[${PYTHON_USEDEP}]
"
DEPEND="${CDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/backports-shutil_get_terminal_size[${PYTHON_USEDEP}]
	virtual/python-typing[${PYTHON_USEDEP}]
	test? (
		dev-python/ipykernel[${PYTHON_USEDEP}]
		dev-python/nbformat[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/testpath[${PYTHON_USEDEP}]
	)
	doc? (
		dev-python/ipykernel[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinxcontrib-websupport[${PYTHON_USEDEP}]
	)"

PDEPEND="
	notebook? (
		dev-python/notebook[${PYTHON_USEDEP}]
		dev-python/ipywidgets[${PYTHON_USEDEP}]
	)
	qt5? ( dev-python/qtconsole[${PYTHON_USEDEP}] )
	smp? ( dev-python/ipyparallel[${PYTHON_USEDEP}] )"

PATCHES=( "${FILESDIR}"/2.1.0-substitute-files.patch )

DISTUTILS_IN_SOURCE_BUILD=1

python_prepare_all() {
	# Remove out of date insource files
	rm IPython/extensions/cythonmagic.py || die
	rm IPython/extensions/rmagic.py || die

	# Prevent un-needed download during build
	if use doc; then
		sed -e "/^    'sphinx.ext.intersphinx',/d" -i docs/source/conf.py || die
	fi

	sed -i \
		-e "s/return \[e % '' for e in ep\] + \[e % suffix for e in ep\]/return \[e % suffix for e in ep\]/" \
		setupbase.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		emake -C docs html_noapi
		HTML_DOCS=( docs/build/html/. )
	fi
}

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	distutils_install_for_testing
	pushd "${TEST_DIR}" >/dev/null || die
	"${TEST_DIR}"/scripts/iptest || die
	popd >/dev/null || die
}

python_install() {
	distutils-r1_python_install

	# Create ipythonX.Y symlinks.
	# TODO:
	# 1. do we want them for pypy? No.  pypy has no numpy
	# 2. handle it in the eclass instead (use _python_ln_rel).
	# With pypy not an option the dosym becomes unconditional
	dosym ../lib/python-exec/${EPYTHON}/ipython \
		/usr/bin/ipython${EPYTHON#python}

	mv "${D}/usr/share/man/man1/ipython.1" "${D}/usr/share/man/man1/ipython2.1" || die
}

python_install_all() {
	distutils-r1_python_install_all

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}

pkg_postinst() {
	optfeature "sympyprinting" dev-python/sympy
	optfeature "cythonmagic" dev-python/cython
	optfeature "%lprun magic command" dev-python/line_profiler
	optfeature "%mprun magic command" dev-python/memory_profiler

	if use nbconvert; then
		if ! has_version app-text/pandoc ; then
			einfo "Node.js will be used to convert notebooks to other formats"
			einfo "like HTML. Support for that is still experimental. If you"
			einfo "encounter any problems, please use app-text/pandoc instead."
		fi
	fi
}
