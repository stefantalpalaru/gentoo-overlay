# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi virtualx xdg-utils

DESCRIPTION="Observation planning package for astronomers"
HOMEPAGE="https://astroplan.readthedocs.org/"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"

RDEPEND="
	dev-python/astropy[${PYTHON_USEDEP}]
	dev-python/pytz:python2[${PYTHON_USEDEP}]
	!<dev-python/astroplan-0.2.1-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/astropy-helpers[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
	  dev-python/sphinx[${PYTHON_USEDEP}]
	  dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}] )
	test? ( dev-python/pytest-mpl[${PYTHON_USEDEP}] )"

PATCHES=( "${FILESDIR}"/${PN}-0.2-ephem-import.patch )

python_prepare_all() {
	# use system astropy-helpers instead of bundled one
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
	echo 'backend: Agg' > "${WORKDIR}"/matplotlibrc || die
	MATPLOTLIBRC="${WORKDIR}" virtx esetup.py test
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
