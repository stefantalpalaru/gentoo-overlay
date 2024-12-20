# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Optimized cosmic ray annihilation astropy python module"
HOMEPAGE="https://github.com/astropy/astroscrappy"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc openmp test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/astropy[${PYTHON_USEDEP}]
	dev-python/astropy-helpers[${PYTHON_USEDEP}]
	dev-python/numpy:python2[${PYTHON_USEDEP}]
	dev-python/scipy:python2[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

DOCS=( CHANGES.rst )

PATCHES=(
	"${FILESDIR}/${PN}-1.0.5-respect-user-flag.patch"
	"${FILESDIR}"/astroscrappy-1.0.5-openmp.patch
)

python_prepare_all() {
	# use astropy-helpers from system
	sed -i -e '/auto_use/s/True/False/' setup.cfg || die
	# if the user explicitely does not want openmp, do not forcefully use it
	if ! use openmp; then
		sed -e 's/if has_openmp/if False/' \
			-i astroscrappy/utils/setup_package.py || die
	fi
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && esetup.py build_sphinx
}

python_test() {
	esetup.py test
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
