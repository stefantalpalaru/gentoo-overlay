# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PV="${PV/_alpha/a}"

DESCRIPTION="Python  for managing the World Coordinate System"
HOMEPAGE="http://gwcs.readthedocs.org"
SRC_URI="https://github.com/spacetelescope/gwcs/archive/${MY_PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="mirror !test? ( test )"

RDEPEND="
	dev-python/astropy[${PYTHON_USEDEP}]
	dev-python/asdf[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/configparser[${PYTHON_USEDEP}]' python2_7 )"
DEPEND="${RDEPEND}
	dev-python/astropy-helpers[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

python_prepare_all() {
	# use system astropy-helpers instead of bundled one
	sed -i -e '/auto_use/s/True/False/' setup.cfg || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		python_setup
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
