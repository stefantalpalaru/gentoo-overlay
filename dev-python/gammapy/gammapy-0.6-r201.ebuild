# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 optfeature pypi virtualx xdg-utils

DESCRIPTION="Python package for gamma-ray astronomy"
HOMEPAGE="https://gammapy.readthedocs.org/"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
DOCS=( README.rst )

RDEPEND="
	dev-python/astropy[${PYTHON_USEDEP}]
	dev-python/click:python2[${PYTHON_USEDEP}]
	dev-python/numpy:python2[${PYTHON_USEDEP}]
	dev-python/regions[${PYTHON_USEDEP}]
	!<dev-python/gammapy-0.6-r200[${PYTHON_USEDEP}]
"

DEPEND="${RDEPEND}
	dev-python/astropy-helpers[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

python_prepare_all() {
	sed -i -e '/auto_use/s/True/False/' setup.cfg || die
	xdg_environment_reset
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		python_setup
		VARTEXFONTS="${T}"/fonts \
			MPLCONFIGDIR="${BUILD_DIR}" \
			PYTHONPATH="${BUILD_DIR}"/lib \
			esetup.py build_sphinx --no-intersphinx
	fi
}

python_test() {
	virtx esetup.py test
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}

pkg_postinst() {
	optfeature "${PN} full functionality" \
			   dev-python/aplpy \
			   dev-python/astroplan \
			   dev-python/gwcs \
			   dev-python/h5py \
			   dev-python/iminuit \
			   dev-python/matplotlib \
			   dev-python/naima \
			   dev-python/pandas \
			   dev-python/photutils \
			   dev-python/reproject \
			   dev-python/uncertainties \
			   dev-python/wcsaxes \
			   dev-python/scipy \
			   dev-python/scikit-image \
			   dev-python/scikit-learn \
	# not yet in portage: sherpa
}
