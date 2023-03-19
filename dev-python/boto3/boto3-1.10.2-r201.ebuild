# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="The AWS SDK for Python"
HOMEPAGE="https://github.com/boto/boto3"
LICENSE="Apache-2.0"
SLOT="python2"
SRC_URI="https://github.com/boto/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/botocore-1.12.4:python2[${PYTHON_USEDEP}]
	dev-python/jmespath:python2[${PYTHON_USEDEP}]
	dev-python/s3transfer:python2[${PYTHON_USEDEP}]
	!<dev-python/boto3-1.10.2-r3[${PYTHON_USEDEP}]
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
	)
"

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	nosetests -v tests/unit/ tests/functional/ || die "test failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/build/html/. )

	distutils-r1_python_install_all
}
