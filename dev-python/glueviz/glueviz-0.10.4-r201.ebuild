# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 optfeature pypi virtualx xdg-utils

DESCRIPTION="Python library to explore relationships within and among related datasets"
HOMEPAGE="http://www.glueviz.org/"
LICENSE="BSD MIT"
SLOT="python2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

# as of 0.10.0; broken
RESTRICT="test"

DOCS=( README.rst )

RDEPEND="
	dev-python/astropy[${PYTHON_USEDEP}]
	dev-python/matplotlib:python2[${PYTHON_USEDEP}]
	dev-python/numpy:python2[${PYTHON_USEDEP}]
	dev-python/pandas:python2[${PYTHON_USEDEP}]
	dev-python/qtpy:python2[${PYTHON_USEDEP},designer,gui]
	!<dev-python/glueviz-0.10.4-r200[${PYTHON_USEDEP}]
"

DEPEND="${RDEPEND}
	dev-python/astropy-helpers[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		  dev-python/glue-vispy-viewers[${PYTHON_USEDEP}]
		  dev-python/mock[${PYTHON_USEDEP}]
		  dev-python/pytest[${PYTHON_USEDEP}]
		  dev-python/qtconsole[${PYTHON_USEDEP}]
		  dev-python/qtpy[${PYTHON_USEDEP},designer,gui,testlib]
	)
"

python_test() {
	virtx esetup.py test
}

pkg_postinst() {
	optfeature "Interactive Ipython terminal" \
			   dev-python/ipython \
			   dev-python/ipykernel \
			   dev-python/qtconsole \
			   dev-python/traitlets \
			   dev-python/pygments \
			   dev-python/zmq
	optfeature "Parse AVM metadata" dev-python/pyavm
	optfeature "Save ${PN} sessions" dev-python/dill
	optfeature "Support HDF5 files" dev-python/h5py
	optfeature "Image processing calculations" dev-python/scipy
	optfeature "Read popular image formats" dev-python/scikit-image
	optfeature "Interact with Ginga viewer" dev-python/ginga
	optfeature "Export plots to plot.ly" dev-python/plotly
	optfeature "Support Excel reading" dev-python/xlrd
	optfeature "Used to read in spectral cubes" dev-python/spectral-cube
	optfeature "Support astronomy dendograms" dev-python/astrodendro

	# Update mimedb for the new .desktop file
	xdg_mimeinfo_database_update
}
