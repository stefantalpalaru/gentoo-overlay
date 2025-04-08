# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 toolchain-funcs elisp-common

DESCRIPTION="A Python to C compiler"
HOMEPAGE="https://cython.org https://pypi.org/project/Cython/
	https://github.com/cython/cython"
SRC_URI="https://github.com/cython/cython/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="emacs test"
RESTRICT="mirror !test? ( test )"

RDEPEND="
	emacs? ( >=app-editors/emacs-23.1:* )
	!<dev-python/cython-0.29.21-r200[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/cython-0.29.14-sphinx-update.patch"
	"${FILESDIR}/cython-0.29.21-spawn-multiprocessing.patch"
)

SITEFILE=50cython-gentoo.el

distutils_enable_sphinx docs

python_prepare_all() {
	sed -i \
		-e "s/'cython = Cython.Compiler.Main:setuptools_main'/'cython_py2 = Cython.Compiler.Main:setuptools_main'/" \
		-e "s/'cythonize = Cython.Build.Cythonize:main'/'cythonize_py2 = Cython.Build.Cythonize:main'/" \
		-e "s/'cygdb = Cython.Debugger.Cygdb:main'/'cygdb_py2 = Cython.Debugger.Cygdb:main'/" \
		setup.py || die
	distutils-r1_python_prepare_all
}

python_compile() {
	local CFLAGS="${CFLAGS} -fno-strict-aliasing"
	local CXXFLAGS="${CXXFLAGS} -fno-strict-aliasing"

	# Python gets confused when it is in sys.path before build.
	local -x PYTHONPATH=

	distutils-r1_python_compile
}

python_compile_all() {
	use emacs && elisp-compile Tools/cython-mode.el
}

python_test() {
	tc-export CC
	# https://github.com/cython/cython/issues/1911
	local -x CFLAGS="${CFLAGS} -fno-strict-overflow"
	"${PYTHON}" runtests.py -vv --work-dir "${BUILD_DIR}"/tests \
		|| die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	local DOCS=( CHANGES.rst README.rst ToDo.txt USAGE.txt )
	distutils-r1_python_install_all

	if use emacs; then
		elisp-install ${PN} Tools/cython-mode.*
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
