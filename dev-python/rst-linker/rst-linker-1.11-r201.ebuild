# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
MY_PN="${PN/-/.}"
PYPI_PN="${MY_PN}"
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Sphinx plugin to add links and timestamps to the changelog"
HOMEPAGE="https://github.com/jaraco/rst.linker"
S="${WORKDIR}/${MY_PN}-${PV}"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 s390 sparc x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/importlib-metadata:python2[${PYTHON_USEDEP}]
	dev-python/python-dateutil:python2[${PYTHON_USEDEP}]
	dev-python/six:python2[${PYTHON_USEDEP}]
	!<dev-python/rst-linker-1.11-r200[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/setuptools-scm-1.15.0[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/jaraco-packaging-3.2[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	test? (
		${RDEPEND}
		dev-python/path[${PYTHON_USEDEP}]
		>=dev-python/pytest-3.4[${PYTHON_USEDEP}]
	)
"

python_compile_all() {
	if use doc; then
		sphinx-build docs docs/_build/html || die
		HTML_DOCS=( docs/_build/html/. )
	fi
}

python_test() {
	# Ignore the module from ${S}, use the one from ${BUILD_DIR}
	# Otherwise, ImportMismatchError may occur
	# https://github.com/gentoo/gentoo/pull/1622#issuecomment-224482396
	# Override pytest options to skip flake8
	py.test -v --ignore=rst --override-ini="addopts=--doctest-modules" \
		|| die "tests failed with ${EPYTHON}"
}
