# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Python module to describe statistical models and design matrices"
HOMEPAGE="https://patsy.readthedocs.org/en/latest/index.html
			https://github.com/pydata/patsy"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="
	dev-python/numpy:python2[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/scipy:python2[${PYTHON_USEDEP}]
	!<dev-python/patsy-0.5.1-r200[${PYTHON_USEDEP}]
"
BDEPEND="
	doc? (
		dev-python/ipython[${PYTHON_USEDEP}]
		dev-python/matplotlib:python2[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		)
"

distutils_enable_tests nose

python_compile_all() {
	use doc && emake -C doc html
}

python_install_all() {
	use doc && HTML_DOCS=( doc/_build/html/. )
	distutils-r1_python_install_all
}
