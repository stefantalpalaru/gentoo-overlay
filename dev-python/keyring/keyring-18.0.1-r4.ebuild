# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Provides access to the system keyring service"
HOMEPAGE="https://github.com/jaraco/keyring"
LICENSE="PSF-2"
SLOT="python2"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/secretstorage[${PYTHON_USEDEP}]
	dev-python/entrypoints[${PYTHON_USEDEP}]
	!<dev-python/keyring-18.0.1-r3[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools-scm-1.15.0[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/jaraco-packaging-3.2[${PYTHON_USEDEP}]
		>=dev-python/rst-linker-1.9[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/pytest-3.7.4[${PYTHON_USEDEP}]
		${RDEPEND}
	)
"

python_prepare_all() {
	sed -i \
		-e 's/keyring=keyring.cli:main/keyring_py2=keyring.cli:main/' \
		setup.cfg || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		sphinx-build docs docs/_build/html || die
		HTML_DOCS=( docs/_build/html/. )
	fi
}

python_test() {
	# Override pytest options to skip flake8
	# Skip an interactive test
	pytest -vv --override-ini="addopts=--doctest-modules" \
		--ignore ${PN}/tests/backends/test_kwallet.py \
		|| die "testsuite failed under ${EPYTHON}"
}
