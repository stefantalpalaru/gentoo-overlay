# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=manual

inherit distutils-r1

DESCRIPTION="Wraps the best available JSON implementation available in a common interface"
HOMEPAGE="https://bitbucket.org/runeh/anyjson"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="test"

# please keep all supported implementations in 'test?'
# to make sure the package is used in the widest way
DEPEND="${RDEPEND}
	dev-python/setuptools:0[${PYTHON_USEDEP}]
	test? (
		dev-python/nose:0[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/simplejson[${PYTHON_USEDEP}]' -2)
	)"

python_test() {
	cp -r -l tests "${BUILD_DIR}" || die
	if [[ ${EPYTHON} == python3* ]]; then
		2to3 -w --no-diffs "${BUILD_DIR}"/tests || die
	fi

	nosetests -w "${BUILD_DIR}"/tests || die "Tests fail with ${EPYTHON}"
}
