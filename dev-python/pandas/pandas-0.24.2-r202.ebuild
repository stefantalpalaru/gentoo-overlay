# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"

VIRTUALX_REQUIRED="manual"

inherit distutils-r1 flag-o-matic optfeature pypi virtualx

DESCRIPTION="Powerful data structures for data analysis and statistics"
HOMEPAGE="http://pandas.pydata.org/
		https://github.com/pandas-dev/pandas"
S="${WORKDIR}/${P/_/}"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc full-support minimal test X"
RESTRICT="!test? ( test )"

RECOMMENDED_DEPEND="
	>=dev-python/bottleneck-1.2.1:python2[${PYTHON_USEDEP}]
	>=dev-python/numexpr-2.1:python2[${PYTHON_USEDEP}]
"
OPTIONAL_DEPEND="
	dev-python/beautifulsoup4:python2[${PYTHON_USEDEP}]
	dev-python/blosc:python2[${PYTHON_USEDEP}]
	dev-python/boto:python2[${PYTHON_USEDEP}]
	>=dev-python/google-api-python-client-1.2.0:python2[${PYTHON_USEDEP}]
	|| (
		dev-python/html5lib:python2[${PYTHON_USEDEP}]
		dev-python/lxml:python2[${PYTHON_USEDEP}]
	)
	dev-python/httplib2:python2[${PYTHON_USEDEP}]
	dev-python/jinja2:python2[${PYTHON_USEDEP}]
	dev-python/matplotlib:python2[${PYTHON_USEDEP}]
	|| (
		>=dev-python/openpyxl-1.6.1:python2[${PYTHON_USEDEP}]
		dev-python/xlsxwriter[${PYTHON_USEDEP}]
	)
	>=dev-python/tables-3.2.1:python2[${PYTHON_USEDEP}]
	dev-python/python-gflags:python2[${PYTHON_USEDEP}]
	dev-python/rpy2:python2[${PYTHON_USEDEP}]
	dev-python/statsmodels:python2[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-0.8.1:python2[${PYTHON_USEDEP}]
	>=dev-python/xarray-0.10.8:python2[${PYTHON_USEDEP}]
	dev-python/xlrd:python2[${PYTHON_USEDEP}]
	dev-python/xlwt:python2[${PYTHON_USEDEP}]
	dev-python/scipy:python2[${PYTHON_USEDEP}]
	X? (
		|| (
			dev-python/pyqt5[${PYTHON_USEDEP}]
			dev-python/pygtk[${PYTHON_USEDEP}]
		)
		|| (
			x11-misc/xclip
			x11-misc/xsel
		)
	)
"
COMMON_DEPEND="
	>dev-python/numpy-1.7:python2[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.5.0:python2[${PYTHON_USEDEP}]
	dev-python/pytz:python2[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/cython-0.23[${PYTHON_USEDEP}]
"
DEPEND="${COMMON_DEPEND}
	dev-python/setuptools:python2[${PYTHON_USEDEP}]
	doc? (
		${VIRTUALX_DEPEND}
		app-text/pandoc
		dev-python/beautifulsoup4:python2[${PYTHON_USEDEP}]
		dev-python/html5lib[${PYTHON_USEDEP}]
		dev-python/ipython[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/matplotlib:python2[${PYTHON_USEDEP}]
		dev-python/nbsphinx[${PYTHON_USEDEP}]
		>=dev-python/openpyxl-1.6.1[${PYTHON_USEDEP}]
		>=dev-python/tables-3.0.0[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
		dev-python/rpy2[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.2.1[${PYTHON_USEDEP}]
		dev-python/xlrd[${PYTHON_USEDEP}]
		dev-python/xlwt[${PYTHON_USEDEP}]
		dev-python/scipy:python2[${PYTHON_USEDEP}]
		x11-misc/xclip
	)
	test? (
		${VIRTUALX_DEPEND}
		${RECOMMENDED_DEPEND}
		${OPTIONAL_DEPEND}
		dev-python/beautifulsoup4:python2[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/pymysql[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/psycopg:python2[${PYTHON_USEDEP}]
		x11-misc/xclip
		x11-misc/xsel
	)
"
# dev-python/statsmodels invokes a circular dep
#  hence rm from doc? ( ), again
RDEPEND="${COMMON_DEPEND}
	!<dev-python/numexpr-2.1[${PYTHON_USEDEP}]
	!~dev-python/openpyxl-1.9.0[${PYTHON_USEDEP}]
	!<dev-python/pandas-0.24.2-r2[${PYTHON_USEDEP}]
	!minimal? ( ${RECOMMENDED_DEPEND} )
	full-support? ( ${OPTIONAL_DEPEND} )
"

PATCHES=(
	"${FILESDIR}/${PN}-0.24.2-skip-broken-test.patch"
)

python_prepare_all() {
	# Prevent un-needed download during build
	sed -e "/^              'sphinx.ext.intersphinx',/d" \
		-i doc/source/conf.py || die

	append-cflags "-fpermissive"

	distutils-r1_python_prepare_all
}

python_compile_all() {
	# To build docs the need be located in $BUILD_DIR,
	# else PYTHONPATH points to unusable modules.
	if use doc; then
		cd "${BUILD_DIR}"/lib || die
		cp -ar "${S}"/doc . && cd doc || die
		LANG=C PYTHONPATH=. virtx ${EPYTHON} make.py html || die
	fi
}

python_test() {
	pushd  "${BUILD_DIR}"/lib > /dev/null
	"${EPYTHON}" -c "import pandas; pandas.show_versions()" || die
	PYTHONPATH=. virtx pytest pandas -v --skip-slow --skip-network \
		-m "not single"
	popd > /dev/null
}

python_install_all() {
	if use doc; then
		dodoc -r "${BUILD_DIR}"/lib/doc/build/html
		einfo "An initial build of docs is absent of references to statsmodels"
		einfo "due to circular dependency. To have them included, emerge"
		einfo "statsmodels next and re-emerge pandas with USE doc"
	fi

	distutils-r1_python_install_all
}

pkg_postinst() {
	optfeature "accelerating certain types of NaN evaluations, using specialized cython routines to achieve large speedups." dev-python/bottleneck
	optfeature "accelerating certain numerical operations, using multiple cores as well as smart chunking and caching to achieve large speedups" ">=dev-python/numexpr-2.1"
	optfeature "needed for pandas.io.html.read_html" dev-python/beautifulsoup4:python2 dev-python/html5lib dev-python/lxml
	optfeature "for msgpack compression using blosc" dev-python/blosc
	optfeature "necessary for Amazon S3 access" dev-python/boto
	optfeature "needed for pandas.io.gbq" dev-python/httplib2 dev-python/setuptools dev-python/python-gflags ">=dev-python/google-api-python-client-1.2.0"
	optfeature "Template engine for conditional HTML formatting" dev-python/jinja2
	optfeature "Plotting support" dev-python/matplotlib
	optfeature "Needed for Excel I/O" ">=dev-python/openpyxl-1.6.1" dev-python/xlsxwriter dev-python/xlrd dev-python/xlwt
	optfeature "necessary for HDF5-based storage" ">=dev-python/tables-3.2.1"
	optfeature "R I/O support" dev-python/rpy2
	optfeature "Needed for parts of pandas.stats" dev-python/statsmodels
	optfeature "SQL database support" ">=dev-python/sqlalchemy-0.8.1"
	optfeature "miscellaneous statistical functions" dev-python/scipy
	optfeature "necessary to use pandas.io.clipboard.read_clipboard support" dev-python/pyqt5 dev-python/pygtk x11-misc/xclip x11-misc/xsel
}
