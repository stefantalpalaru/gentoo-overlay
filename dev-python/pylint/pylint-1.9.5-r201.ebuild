# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 optfeature pypi

DESCRIPTION="Python code static checker"
HOMEPAGE="https://www.logilab.org/project/pylint
	https://pypi.org/project/pylint/
	https://github.com/pycqa/pylint"
LICENSE="GPL-2"
SLOT="python2"
KEYWORDS="~alpha amd64 arm ppc ppc64 sparc x86"
IUSE="doc examples test"
RESTRICT="mirror test" # multiple failures

RDEPEND="
	>=dev-python/astroid-1.6.0:python2[${PYTHON_USEDEP}]
	<dev-python/astroid-2.0:python2[${PYTHON_USEDEP}]
	dev-python/six:python2[${PYTHON_USEDEP}]
	>=dev-python/isort-4.2.5:python2[${PYTHON_USEDEP}]
	dev-python/mccabe:python2[${PYTHON_USEDEP}]
	dev-python/backports-functools-lru-cache[${PYTHON_USEDEP}]
	dev-python/configparser[${PYTHON_USEDEP}]
	!<dev-python/pylint-1.9.5-r3[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-python/pytest-runner[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
"

# Usual. Requ'd for impl specific failures in test phase
DISTUTILS_IN_SOURCE_BUILD=1

python_prepare_all() {
	sed -i \
		-e "s/'pylint = pylint:run_pylint'/'pylint_py2 = pylint:run_pylint'/" \
		-e "s/'epylint = pylint:run_epylint'/'epylint_py2 = pylint:run_epylint'/" \
		-e "s/'pyreverse = pylint:run_pyreverse'/'pyreverse_py2 = pylint:run_pyreverse'/" \
		-e "s/'symilar = pylint:run_symilar'/'symilar_py2 = pylint:run_symilar'/" \
		setup.py || die
	sed -i \
		-e 's/scripts = /foobar = /' \
		pylint/__pkginfo__.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	# selection of straight html triggers a trivial annoying bug, we skirt it
	use doc && PYTHONPATH="${S}" emake -e -C doc singlehtml
}

python_test() {
	${EPYTHON} \
		-m unittest discover \
		-s pylint/test/ -p "*test_*".py \
		--verbose || die
}

python_install_all() {
	#doman man/{pylint,pyreverse}.1
	if use examples ; then
		docinto examples
		dodoc -r examples/.
	fi
	use doc && local HTML_DOCS=( doc/_build/singlehtml/. )
	distutils-r1_python_install_all
	rm -rf "${ED}/usr/$(get_libdir)/python2.7/site-packages/pylint/test"
	python_optimize
}

pkg_postinst() {
	# Optional dependency on "tk" USE flag would break support for Jython.
	optfeature "pylint-gui script requires dev-lang/python with \"tk\" USE flag enabled." dev-lang/python[tk]
}
