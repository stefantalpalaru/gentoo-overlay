# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Low-level, data-driven core of boto 3."
HOMEPAGE="https://github.com/boto/botocore"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="mirror !test? ( test )"

RDEPEND="
	dev-python/docutils:python2[${PYTHON_USEDEP}]
	dev-python/jmespath:python2[${PYTHON_USEDEP}]
	dev-python/python-dateutil:python2[${PYTHON_USEDEP}]
	dev-python/urllib3:python2[${PYTHON_USEDEP}]
	!<dev-python/botocore-1.14.17-r2[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		dev-python/guzzle_sphinx_theme[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	test? (
		${RDEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/jsonschema[${PYTHON_USEDEP}]
	)
"

PATCHES=( "${FILESDIR}/1.8.6-tests-pass-all-env-vars-to-cmd-runner.patch" )

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	PYTHONPATH="${BUILD_DIR}/lib" nosetests -v tests/unit || die "unit tests failed under ${EPYTHON}"
	PYTHONPATH="${BUILD_DIR}/lib" nosetests -v tests/functional || die "functional tests failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/build/html/. )

	distutils-r1_python_install_all
}
