# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 flag-o-matic pypi

DESCRIPTION="Hierarchical datasets for Python"
HOMEPAGE="https://www.pytables.org/"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-arch/bzip2:0=
	app-arch/lz4:0=
	>=app-arch/zstd-1.0.0:=
	>=dev-libs/c-blosc-1.11.1:0=
	dev-libs/lzo:2=
	>=dev-python/numpy-1.8.1:python2[${PYTHON_USEDEP}]
	>=dev-python/numexpr-2.5.2:python2[${PYTHON_USEDEP}]
	dev-python/six:python2[${PYTHON_USEDEP}]
	>=sci-libs/hdf5-1.8.15:0=
	!<dev-python/tables-3.4.4-r3[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	>=dev-python/cython-0.21[${PYTHON_USEDEP}]
	test? ( dev-python/mock[${PYTHON_USEDEP}] )
"

DOCS=( RELEASE_NOTES.txt THANKS )

python_prepare_all() {
	export HDF5_DIR="${EPREFIX}"/usr
	rm tables/*.c || die
	sed -e "s:/usr:${EPREFIX}/usr:g" \
		-i setup.py || die
	rm -r c-blosc/{blosc,internal-complibs} || die
	sed -i -e '/_version/ s/\\s\*/\\s\+/' setup.py || die
	distutils-r1_python_prepare_all
}

python_compile() {
	local -x CFLAGS="${CFLAGS}"
	append-cflags -fno-strict-aliasing
	distutils-r1_python_compile
}

python_test() {
	cd "${BUILD_DIR}"/lib* || die
	${EPYTHON} tables/tests/test_all.py || die
}

python_install_all() {
	if use doc; then
		DOCS+=( doc/scripts )
	fi
	distutils-r1_python_install_all

	for binary in "${ED}/usr/bin"/*; do
		mv "${binary}" "${binary}_py2"
	done

	if use examples; then
		dodoc -r examples
		dodoc -r contrib
		docompress -x /usr/share/doc/${PF}/examples
		docompress -x /usr/share/doc/${PF}/contrib
	fi
}
