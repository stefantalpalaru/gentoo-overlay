# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Compatibility API between asyncio/Twisted/Trollius"
HOMEPAGE="https://github.com/crossbario/txaio https://pypi.org/project/txaio/"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="amd64 arm ~arm64 x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/sphinx-1.2.3[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-spelling-2.1.2[${PYTHON_USEDEP}]
		>=dev-python/sphinx-rtd-theme-0.1.9[${PYTHON_USEDEP}]
	)
	test? ( >=dev-python/pytest-2.6.4[${PYTHON_USEDEP}]
		>=dev-python/mock-1.3.0[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	!<dev-python/txaio-2.9.0-r200[${PYTHON_USEDEP}]
"

src_prepare() {
	default_src_prepare
	# Take out failing tests known to pass when run manually
	# we certainly don't need to test "python setup.py sdist" here
	rm "${S}/test/test_packaging.py" || die
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	pytest -v || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	use doc && HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
