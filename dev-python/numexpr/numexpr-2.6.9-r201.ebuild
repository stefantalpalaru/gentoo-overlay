# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 flag-o-matic pypi

DESCRIPTION="Fast numerical array expression evaluator for Python and NumPy"
HOMEPAGE="https://github.com/pydata/numexpr"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="mkl"

RDEPEND="
	>=dev-python/numpy-1.6:python2[${PYTHON_USEDEP}]
	mkl? ( sci-libs/mkl )
	!<dev-python/numexpr-2.6.9-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_prepare_all() {
	# TODO: mkl can be used but it fails for me
	# only works with mkl in tree. newer mkl will use pkgconfig
	if use mkl; then
		use amd64 && local ext="_lp64"
		cat > site.cfg <<- _EOF_ || die
		[mkl]
		library_dirs = ${MKLROOT}/lib/em64t
		include_dirs = ${MKLROOT}/include
		mkl_libs = mkl_solver${ext}, mkl_intel${ext}, \
		mkl_intel_thread, mkl_core, iomp5
		_EOF_
	fi

	distutils-r1_python_prepare_all
}

python_compile() {
	local -x CFLAGS="${CFLAGS}"
	append-cflags -fno-strict-aliasing

	distutils-r1_python_compile
}

python_test() {
	pushd "${BUILD_DIR}"/lib >/dev/null || die
	"${EPYTHON}" \
		-c "import sys;import numexpr;sys.exit(0 if numexpr.test() else 1)" \
		|| die
	pushd >/dev/null || die
}
