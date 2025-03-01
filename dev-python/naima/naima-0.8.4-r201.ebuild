# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi xdg-utils

DESCRIPTION="Python package for gamma-ray astronomy"
HOMEPAGE="http://naima.readthedocs.io/"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/astropy[${PYTHON_USEDEP}]
	dev-python/corner[${PYTHON_USEDEP}]
	dev-python/emcee[${PYTHON_USEDEP}]
	dev-python/h5py:python2[${PYTHON_USEDEP}]
	dev-python/numpy:python2[${PYTHON_USEDEP}]
	dev-python/pyyaml:python2[${PYTHON_USEDEP}]
	dev-python/scipy:python2[${PYTHON_USEDEP}]
	!<dev-python/naima-0.8.4-r200[${PYTHON_USEDEP}]
"

DEPEND="${RDEPEND}
	dev-python/astropy-helpers[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (	dev-python/pytest[${PYTHON_USEDEP}] )"

DOCS=( README.rst CHANGES.rst )

python_prepare_all() {
	sed -e '/auto_use/s/True/False/' -i setup.cfg || die
	xdg_environment_reset
	# issues during install time (bug #604012)
	addpredict /proc/mtrr
	addpredict /sys/devices/system/cpu/
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
	esetup.py test
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
