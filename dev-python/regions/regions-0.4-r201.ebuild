# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1 virtualx xdg-utils pypi

DESCRIPTION="Astropy affiliated package for region handling"
HOMEPAGE="http://astropy-regions.readthedocs.org/"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="!test? ( test )"
RDEPEND="
	dev-python/astropy[${PYTHON_USEDEP}]
	dev-python/matplotlib:python2[${PYTHON_USEDEP}]
	dev-python/numpy:python2[${PYTHON_USEDEP}]
	dev-python/six:python2[${PYTHON_USEDEP}]
	!<dev-python/regions-0.4-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/astropy-helpers[${PYTHON_USEDEP}]
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
		dev-python/wcsaxes[${PYTHON_USEDEP}] )
	test? (
		dev-python/pytest-mpl[${PYTHON_USEDEP}]
		dev-python/pytest-arraydiff[${PYTHON_USEDEP}]
		dev-python/wcsaxes[${PYTHON_USEDEP}]
		dev-python/scipy:python2[${PYTHON_USEDEP}] )"

python_prepare_all() {
	# use astropy-helpers from system
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
	export MATPLOTLIBRC="${WORKDIR}"
	virtx esetup.py test
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
