# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 flag-o-matic pypi

DESCRIPTION="Python multiprocessing fork"
HOMEPAGE="https://pypi.org/project/billiard/
		https://github.com/celery/billiard"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 x86"
IUSE="doc test"
RESTRICT="mirror !test? ( test )"

RDEPEND="!<dev-python/billiard-3.5.0.2-r3[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		>=dev-python/case-1.3.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-3.0[${PYTHON_USEDEP}]
	)"
# The usual req'd for tests
DISTUTILS_IN_SOURCE_BUILD=1

python_compile() {
	local CFLAGS=${CFLAGS}
	append-cflags -fno-strict-aliasing
	distutils-r1_python_compile
}

python_compile_all() {
	use doc && esetup.py build_sphinx --builder="html" --source-dir=Doc/
}

python_test() {
	esetup.py test
}

python_install_all() {
	use doc && local HTML_DOCS=( build/sphinx/html/. )
	distutils-r1_python_install_all
}
