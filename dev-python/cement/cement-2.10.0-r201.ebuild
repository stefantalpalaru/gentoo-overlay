# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="CLI Application Framework for Python"
HOMEPAGE="https://builtoncement.com/"
SRC_URI="https://github.com/datafolklabs/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
IUSE="test doc examples"

RDEPEND="
	dev-python/pystache:python2[${PYTHON_USEDEP}]
	dev-python/pyyaml:python2[${PYTHON_USEDEP}]
	dev-python/configobj:python2[${PYTHON_USEDEP}]
	dev-python/pylibmc:python2[${PYTHON_USEDEP}]
	dev-python/genshi:python2[${PYTHON_USEDEP}]
	dev-python/colorlog:python2[${PYTHON_USEDEP}]
	!<dev-python/cement-2.10.0-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
	)"

DOCS=( ChangeLog CONTRIBUTORS README.md )

PATCHES=( "${FILESDIR}/${PN}"-2.6.2-exmples.patch )

#https://github.com/datafolklabs/cement/issues/331
RESTRICT=test

python_test() {
	nosetests --verbose || die "Tests fail with ${EPYTHON}"
}

python_compile_all() {
	use doc && esetup.py build_sphinx
}

python_install_all() {
	use doc && HTML_DOCS=( doc/build/html/. )
	use examples && EXAMPLES=( examples )

	distutils-r1_python_install_all
}
