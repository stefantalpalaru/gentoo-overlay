# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Message Passing Interface for Python"
HOMEPAGE="https://bitbucket.org/mpi4py/
		https://pypi.org/project/mpi4py/"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test"
RESTRICT="mirror !test? ( test )"

RDEPEND="virtual/mpi
	!<dev-python/mpi4py-3.0.3-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		virtual/mpi[romio]
	)
"

DISTUTILS_IN_SOURCE_BUILD=1

python_prepare_all() {
	# not needed on install
	rm -vr docs/source || die
	distutils-r1_python_prepare_all
}

src_compile() {
	export FAKEROOTKEY=1
	distutils-r1_src_compile
}

python_test() {
	echo "Beginning test phase"
	pushd "${BUILD_DIR}"/../ &> /dev/null || die
	mpiexec -n 2 "${PYTHON}" ./test/runtests.py -v || die "Testsuite failed under ${EPYTHON}"
	popd &> /dev/null || die
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/. )
	use examples && local DOCS=( demo )
	distutils-r1_python_install_all
}
