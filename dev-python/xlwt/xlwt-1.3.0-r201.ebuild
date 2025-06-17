# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Python library to create spreadsheet files compatible with Excel"
HOMEPAGE="https://pypi.org/project/xlwt/
	https://github.com/python-excel/xlwt"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 arm ~arm64 ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test"
RESTRICT="mirror !test? ( test )"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/sphinx-1.3.1[${PYTHON_USEDEP}]
		dev-python/pkginfo[${PYTHON_USEDEP}]
	)
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"
RDEPEND="
	!<dev-python/xlwt-1.3.0-r200[${PYTHON_USEDEP}]
"

# Prevent d'loading in the doc build
PATCHES=( "${FILESDIR}"/docbuild-r1.patch )

python_prepare_all() {
	# Don't install documentation and examples in site-packages directories.
	sed -e "/package_data/d" -i setup.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	nosetests tests || die "tests failed under ${EPYTHON}}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}
	fi
	distutils-r1_python_install_all
}
