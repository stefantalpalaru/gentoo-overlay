# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 xdg-utils

MYPV=${PV/_/}
S=${WORKDIR}/${PN}-${MYPV}

DESCRIPTION="Core functionality for performing astrophysics with Python"
HOMEPAGE="https://www.astropy.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${PN}-${MYPV}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/expat:0=
	dev-python/beautifulsoup:4-python2[${PYTHON_USEDEP}]
	dev-python/configobj:python2[${PYTHON_USEDEP}]
	dev-python/h5py:python2[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.7:python2[${PYTHON_USEDEP}]
	dev-python/jplephem[${PYTHON_USEDEP}]
	dev-libs/libxml2[${PYTHON_USEDEP}]
	dev-python/matplotlib-python2[${PYTHON_USEDEP}]
	dev-python/mpmath:python2[${PYTHON_USEDEP}]
	>=dev-python/numpy-python2-1.9[${PYTHON_USEDEP}]
	dev-python/objgraph:python2[${PYTHON_USEDEP}]
	dev-python/pandas:python2[${PYTHON_USEDEP}]
	dev-python/pillow:python2[${PYTHON_USEDEP},jpeg(+)]
	dev-python/pytz:python2[${PYTHON_USEDEP}]
	dev-python/pyyaml:python2[${PYTHON_USEDEP}]
	dev-python/six:python2[${PYTHON_USEDEP}]
	>=sci-astronomy/erfa-1.3:0=
	>=sci-astronomy/wcslib-5:0=
	>=sci-libs/cfitsio-3.410:0=
	dev-python/scipy-python2[${PYTHON_USEDEP}]
	sci-libs/scikits_image[${PYTHON_USEDEP}]
	sys-libs/zlib:0=
	!<dev-python/astropy-2.0.14-r200[${PYTHON_USEDEP}]
"
DEPEND="
	>=dev-python/astropy-helpers-2[${PYTHON_USEDEP}]
	>=dev-python/cython-0.21[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.7[${PYTHON_USEDEP}]
	>=dev-python/numpy-python2-1.10[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	virtual/pkgconfig
	doc? (
		${RDEPEND}
		media-gfx/graphviz
		dev-python/pytest[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.6[${PYTHON_USEDEP}]
		>=dev-python/sphinx-gallery-0.1.9[${PYTHON_USEDEP}]
	)
	test? (
		${RDEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-mpl[${PYTHON_USEDEP}]
	)
"

python_prepare_all() {
	export mydistutilsargs="--offline"
	export ASTROPY_USE_SYSTEM_PYTEST=True
	rm -r ${PN}_helpers || die
	rm -r cextern/{expat,erfa,cfitsio,wcslib} || die
	sed -i -e '/auto_use/s/True/False/' setup.cfg || die
	cat >> setup.cfg <<-EOF

		[build]
		use_system_libraries=1
	EOF
	xdg_environment_reset
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		VARTEXFONTS="${T}"/fonts MPLCONFIGDIR="${T}" PYTHONPATH="${BUILD_DIR}"/lib \
				   esetup.py build_docs --no-intersphinx
		HTML_DOCS=( docs/_build/html/. )
	fi
}

python_test() {
	esetup.py test
}
