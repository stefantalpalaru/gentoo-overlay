# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Python bindings for GMP, MPC and MPFR libraries"
HOMEPAGE="https://github.com/aleaxit/gmpy"
SRC_URI="$(pypi_sdist_url "${PN}" "${PV}" .zip)"
LICENSE="LGPL-3+"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="
	>=dev-libs/mpc-1.0.2:=
	>=dev-libs/mpfr-3.1.2:=
	dev-libs/gmp:0=
	!<dev-python/gmpy2-2.0.8-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/unzip"

PATCHES=(
	"${FILESDIR}"/gmpy-2.0.8-test-exit-status.patch
)

distutils_enable_sphinx docs

python_prepare_all() {
	# rm non std test file
	rm test*/gmpy_test_thr.py || die
	# testing for contents of __dir__ is really silly, and fails
	sed -i -e '/__dir__/,+1d' test3/*.py || die
	# fix sphinx-1.8+ compat
	# https://github.com/aleaxit/gmpy/commit/c35c1f3319fcf95e894a59a6d523851bad4abf66
	sed -i -e 's:pngmath:imgmath:' docs/conf.py || die

	distutils-r1_python_prepare_all
}

python_configure_all() {
	DISTUTILS_ARGS=(
		--gmp
	)
}

python_compile() {
	python_is_python3 || local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"
	distutils-r1_python_compile
}

python_test() {
	cd test || die
	"${EPYTHON}" runtests.py || die "tests failed under ${EPYTHON}"
	if python_is_python3; then
		cd ../test3 || die
	else
		cd ../test2 || die
	fi
	"${EPYTHON}" gmpy_test.py || die "tests failed under ${EPYTHON}"
}
