# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
MY_PN="${PN/-/.}"
MY_PN="${MY_PN//-/_}"
PYPI_PN="${MY_PN}"
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Backport of functools.lru_cache from Python 3.3"
HOMEPAGE="https://github.com/jaraco/backports.functools_lru_cache"
S="${WORKDIR}/${MY_PN}-${PV}"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/backports[${PYTHON_USEDEP}]"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/setuptools-scm-1.15.0[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/jaraco-packaging-3.2[${PYTHON_USEDEP}]
		>=dev-python/rst-linker-1.9[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/pytest-2.8[${PYTHON_USEDEP}]
	)
"

python_compile_all() {
	if use doc; then
		cd docs || die
		sphinx-build . _build/html || die
		HTML_DOCS=( docs/_build/html/. )
	fi
}

python_test() {
	# Override pytest options to skip flake8 and friends
	PYTHONPATH=. pytest -vv --override-ini="addopts=--doctest-modules" \
		|| die "tests failed with ${EPYTHON}"
}

python_install() {
	# avoid a collision with dev-python/backports
	rm "${BUILD_DIR}"/lib/backports/__init__.py || die
	distutils-r1_python_install --skip-build
}
