# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_P="${PN}-${PV/_p/.post}"
DESCRIPTION="Backports and enhancements for the contextlib module"
HOMEPAGE="https://pypi.org/project/contextlib2/
		https://github.com/jazzband/contextlib2"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="PSF-2.4"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 s390 sparc x86"
IUSE="test"

DEPEND="
	test? ( dev-python/unittest2[${PYTHON_USEDEP}] )
"
RDEPEND="
	!<dev-python/contextlib2-0.6.0_p1-r3[${PYTHON_USEDEP}]
"

S="${WORKDIR}"/${MY_P}

RESTRICT="!test? ( test )"

DOCS=( NEWS.rst README.rst )

python_prepare_all() {
	sed -i -e 's:unittest.main():unittest.main(verbosity=2):' \
		test_contextlib2.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	"${PYTHON}" test_contextlib2.py || die "Tests fail for ${EPYTHON}"
}
