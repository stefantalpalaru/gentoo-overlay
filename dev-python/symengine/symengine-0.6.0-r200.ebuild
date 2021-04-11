# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MYP=${PN}.py-${PV}

DESCRIPTION="Python wrappers to the symengine C++ library"
HOMEPAGE="https://github.com/symengine/symengine.py"
SRC_URI="https://github.com/symengine/symengine.py/archive/v${PV}.tar.gz -> ${MYP}.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"
RDEPEND="
	dev-python/numpy-python2[${PYTHON_USEDEP}]
	>=sci-libs/symengine-0.4
	!<dev-python/symengine-0.6.0-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MYP}"

python_test() {
	cd "${BUILD_DIR}"
	nosetests -v || die "tests failed with ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_prepare_all
	rm "${ED}"/usr/share/doc/${PF}/README.md || die
	newdoc README.md ${PN}.py.md
}
