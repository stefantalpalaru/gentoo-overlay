# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 pypi

DESCRIPTION="Unittest extension with automatic test suite discovery and easy test authoring"
HOMEPAGE="
	https://pypi.org/project/nose/
	https://nose.readthedocs.io/en/latest/
	https://github.com/nose-devs/nose"

LICENSE="LGPL-2.1"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="coverage examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	coverage? (
		dev-python/coverage:python2[${PYTHON_USEDEP}]
	)
	!<dev-python/nose-1.3.7-r8[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		!hppa? ( dev-python/coverage[${PYTHON_USEDEP}] )
		$(python_gen_cond_dep '
			dev-python/twisted[${PYTHON_USEDEP}]
		' 'python3*')
	)"

PATCHES=(
	"${FILESDIR}"/${P}-python-3.5-backport.patch

	# Patch against master found in an upstream PR, backported:
	# https://github.com/nose-devs/nose/pull/1004
	"${FILESDIR}"/${P}-coverage-4.1-support.patch

	"${FILESDIR}"/${P}-python-3.6-test.patch
)

python_prepare_all() {
	# Tests need to be converted, and they don't respect BUILD_DIR.
	use test && DISTUTILS_IN_SOURCE_BUILD=1

	# Disable tests requiring network connection.
	sed \
		-e "s/test_resolve/_&/g" \
		-e "s/test_raises_bad_return/_&/g" \
		-e "s/test_raises_twisted_error/_&/g" \
		-i unit_tests/test_twisted.py || die "sed failed"
	sed -i \
		-e "/nosetests = nose:run_exit/d" \
		setup.py || die "sed2 failed"

	# fix manpage install path
	sed -i -e 's:man/:share/&:' setup.py || die

	distutils-r1_python_prepare_all
}

python_compile() {
	local add_targets=()

	if use test; then
		add_targets+=( egg_info )
		python_is_python3 && add_targets+=( build_tests )
	fi

	distutils-r1_python_compile "${add_targets[@]}"
}

python_test() {
	"${EPYTHON}" selftest.py -v || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use examples && dodoc -r examples
	distutils-r1_python_install_all
	rm -rf "${D}/usr/share/man"
}
