# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Sphinx spelling extension"
HOMEPAGE="https://github.com/sphinx-contrib/spelling"
LICENSE="BSD-2"
SLOT="python2"
KEYWORDS="amd64 ~arm arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="mirror !test? ( test )"

COMMON_DEPEND="
	dev-python/pbr:python2[${PYTHON_USEDEP}]
	dev-python/pyenchant:python2[${PYTHON_USEDEP}]
	dev-python/six:python2[${PYTHON_USEDEP}]
	dev-python/sphinx:python2[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		${COMMON_DEPEND}
		>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
		dev-python/testtools[${PYTHON_USEDEP}]
	)
"
RDEPEND="${COMMON_DEPEND}
	!<dev-python/sphinxcontrib-spelling-4.3.0-r200[${PYTHON_USEDEP}]
"

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	"${EPYTHON}" -m unittest discover -v || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/build/html/. )
	distutils-r1_python_install_all
	find "${ED}" -name '*.pth' -delete || die
}
