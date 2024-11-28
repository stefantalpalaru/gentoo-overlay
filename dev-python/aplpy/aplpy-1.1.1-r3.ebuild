# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYPI_PN="APLpy"
PYPI_NO_NORMALIZE=1
MYPN=APLpy
MYP=${MYPN}-${PV}

inherit distutils-r1 optfeature pypi virtualx xdg-utils

DESCRIPTION="Astronomical Plotting Library in Python"
HOMEPAGE="https://aplpy.github.com/"
S="${WORKDIR}/${MYP}"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	${PYTHON_DEPS}
	dev-python/astropy[${PYTHON_USEDEP}]
	dev-python/numpy:python2[${PYTHON_USEDEP}]
	dev-python/matplotlib:python2[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/astropy-helpers[${PYTHON_USEDEP}]
	test? ( dev-python/pytest-mpl[${PYTHON_USEDEP}] )"

PATCHES=(
	"${FILESDIR}/${PN}-1.0-fix-dependencies.patch"
)

python_prepare_all() {
	sed -i -e '/auto_use/s/True/False/' setup.cfg || die
	xdg_environment_reset
	distutils-r1_python_prepare_all
}

python_compile() {
	distutils-r1_python_compile --use-system-libraries
}

python_test() {
	distutils_install_for_testing
	cd "${TEST_DIR}" || die
	echo "backend: Agg" > matplotlibrc
	virtx "${EPYTHON}" -c "import aplpy, sys;r = aplpy.test();sys.exit(r)"
}

pkg_postinst() {
	optfeature "Interact with Montage"				dev-python/montage-wrapper
	optfeature "Read DS9 regions files"				dev-python/pyregion
	optfeature "Extend image i/o formats"			dev-python/pillow
	optfeature "Astronomy Visualization Metadata tagging" dev-python/pyavm
}
