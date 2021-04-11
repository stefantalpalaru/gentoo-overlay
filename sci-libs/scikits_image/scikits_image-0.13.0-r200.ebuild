# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils virtualx

MYPN="${PN/scikits_/scikit-}"
MYP="${MYPN}-${PV}"

DESCRIPTION="Image processing routines for SciPy"
HOMEPAGE="http://scikit-image.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${MYPN}/${MYP}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc freeimage pyamg test"

RDEPEND="
	dev-python/matplotlib-python2[${PYTHON_USEDEP}]
	dev-python/networkx:python2[${PYTHON_USEDEP}]
	dev-python/numpy-python2[${PYTHON_USEDEP}]
	dev-python/pillow:python2[${PYTHON_USEDEP}]
	dev-python/pywavelets:python2[${PYTHON_USEDEP}]
	dev-python/six:python2[${PYTHON_USEDEP}]
	dev-python/scipy-python2[sparse,${PYTHON_USEDEP}]
	freeimage? ( media-libs/freeimage )
	pyamg? ( dev-python/pyamg:python2[${PYTHON_USEDEP}] )
	!<sci-libs/scikits_image-0.13.0-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	>=dev-python/cython-0.23[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (	dev-python/nose[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MYP}"

DOCS=( CONTRIBUTORS.txt DEPENDS.txt RELEASE.txt TASKS.txt TODO.txt )

python_test() {
	distutils_install_for_testing
	cd "${TEST_DIR}" || die "no ${TEST_DIR} available"
	echo "backend : Agg" > matplotlibrc || die
	#echo "backend.qt4 : PyQt4" >> matplotlibrc || die
	#echo "backend.qt4 : PySide" >> matplotlibrc || die
	MPLCONFIGDIR=. virtx nosetests --exe -v skimage || die
}

pkg_postinst() {
	optfeature "FITS io capability" dev-python/astropy
	optfeature "GTK" dev-python/pygtk
	optfeature "Parallel computation" dev-python/dask
	# not in portage yet
	#optfeature "io plugin providing a wide variety of formats, including specialized formats using in medical imaging." dev-python/simpleitk
	#optfeature "io plugin providing most standard formats" dev-python/imread
}
