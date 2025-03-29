# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

MY_P="${PN}-${PV/_p/.post}"
DESCRIPTION="Backports and enhancements for the contextlib module"
HOMEPAGE="https://pypi.org/project/contextlib2/
		https://github.com/jazzband/contextlib2"
S="${WORKDIR}"/${MY_P}

LICENSE="PSF-2.4"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~mips ppc ppc64 s390 sparc x86"
IUSE="test"
RESTRICT="mirror !test? ( test )"

DEPEND="
	test? ( dev-python/unittest2[${PYTHON_USEDEP}] )
"
RDEPEND="
	!<dev-python/contextlib2-0.6.0_p1-r3[${PYTHON_USEDEP}]
"

DOCS=( NEWS.rst README.rst )

python_prepare_all() {
	sed -i -e 's:unittest.main():unittest.main(verbosity=2):' \
		test_contextlib2.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	"${PYTHON}" test_contextlib2.py || die "Tests fail for ${EPYTHON}"
}
