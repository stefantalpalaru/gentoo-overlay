# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi flag-o-matic

DESCRIPTION="Python modules for machine learning and data mining"
HOMEPAGE="https://scikit-learn.org"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/joblib:python2[${PYTHON_USEDEP}]
	dev-python/matplotlib:python2[${PYTHON_USEDEP}]
	dev-python/nose:python2[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.11.0:python2[${PYTHON_USEDEP}]
	>=dev-python/scipy-0.17.0:python2[${PYTHON_USEDEP}]
	virtual/blas:=
	virtual/cblas:=
	virtual/python-funcsigs[${PYTHON_USEDEP}]
	!<dev-python/scikit-learn-0.20.4-r200[${PYTHON_USEDEP}]
"

DEPEND="${RDEPEND}
	dev-python/cython:python2[${PYTHON_USEDEP}]
	dev-python/setuptools:python2[${PYTHON_USEDEP}]
	test? ( dev-python/pytest:python2[${PYTHON_USEDEP}]	)
"

PATCHES=(
	"${FILESDIR}/scikits_learn-0.18.1-system-cblas.patch"
	"${FILESDIR}/scikits_learn-0.20.4-cblas-api.patch"
)

python_prepare_all() {
	# bug #397605
	[[ ${CHOST} == *-darwin* ]] \
		&& append-ldflags -bundle "-undefined dynamic_lookup"

	# delete the internal cblas copy
	rm -rf sklearn/src

	# force Cython compilation
	rm PKG-INFO

	# use system joblib
	rm -r sklearn/externals/joblib || die
	sed -i -e '/joblib/d' sklearn/externals/setup.py || die
	for f in sklearn/{*/,}*.py; do
		sed -r -e '/^from/s/(sklearn|\.|)\.externals\.joblib/joblib/' \
			-e 's/from (sklearn|\.|)\.externals import/import/' -i $f || die
	done

	# use system funcsigs
	rm sklearn/externals/funcsigs.py || die
	for f in sklearn/{utils/fixes.py,gaussian_process/{tests/test_,}kernels.py}; do
		sed -r -e 's/from (sklearn|\.|)\.externals\.funcsigs/from funcsigs/' -i $f || die
	done

	append-cflags "-fpermissive"

	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py install \
			  --root="${T}/test-${EPYTHON}" \
			  --no-compile ${SCIPY_FCONFIG}
	pushd "${T}/test-${EPYTHON}/$(python_get_sitedir)" || die > /dev/null
	SKLEARN_SKIP_NETWORK_TESTS=1  py.test -v sklearn || die
	popd > /dev/null
}

python_install() {
	distutils-r1_python_install ${SCIPY_FCONFIG}
}

python_install_all() {
	find "${S}" -name \*LICENSE.txt -delete
	distutils-r1_python_install_all
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

}
