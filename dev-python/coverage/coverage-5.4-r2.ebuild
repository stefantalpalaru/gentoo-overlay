# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+),sqlite(+)"
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 pypi

DESCRIPTION="Code coverage measurement for Python"
HOMEPAGE="https://coverage.readthedocs.io/en/latest/ https://pypi.org/project/coverage/"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"
RESTRICT="mirror test"

RDEPEND="
	!<dev-python/coverage-5.4-r1[${PYTHON_USEDEP}]
"

src_prepare() {
	# avoid the dep on xdist, run tests verbosely
	sed -i -e '/^addopts/s:-n3:-v:' setup.cfg || die
	sed -i \
		-e '/coverage = coverage.cmdline:main/d' \
		setup.py || die
	distutils-r1_src_prepare
}

python_compile() {
	if [[ ${EPYTHON} == python2.7 ]]; then
		local CFLAGS="${CFLAGS} -fno-strict-aliasing"
		export CFLAGS
	fi

	distutils-r1_python_compile
}

python_test() {
	distutils_install_for_testing
	local bindir=${TEST_DIR}/scripts

	pushd tests/eggsrc >/dev/null || die
	distutils_install_for_testing
	popd >/dev/null || die

	"${EPYTHON}" igor.py zip_mods || die
	PATH="${bindir}:${PATH}" "${EPYTHON}" igor.py test_with_tracer py || die

	# No C extensions under pypy
	if [[ ${EPYTHON} != pypy* ]]; then
		cp -l -- "${TEST_DIR}"/lib/*/coverage/*.so coverage/ || die
		PATH="${bindir}:${PATH}" "${EPYTHON}" igor.py test_with_tracer c || die
	fi

	# clean up leftover "egg1" directory
	rm -rf build/lib/egg1 || die
}
