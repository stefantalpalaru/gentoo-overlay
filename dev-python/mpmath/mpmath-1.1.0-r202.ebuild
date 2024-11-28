# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="Python library for arbitrary-precision floating-point arithmetic"
HOMEPAGE="http://mpmath.org/
		https://github.com/fredrik-johansson/mpmath"
SRC_URI="https://github.com/fredrik-johansson/${PN}/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~arm ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="gmp matplotlib test"
RESTRICT="!test? ( test )"

RDEPEND="
	gmp? ( dev-python/gmpy2:python2 )
	matplotlib? (
		dev-python/matplotlib:python2[${PYTHON_USEDEP}]
	)
	!<dev-python/mpmath-1.1.0-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}/${PN}-1.0.0.patch"
		)

	# this test requires X
	rm ${PN}/tests/test_visualization.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	pushd ${PN}/tests >/dev/null
	${EPYTHON} runtests.py -local
	popd >/dev/null
}
