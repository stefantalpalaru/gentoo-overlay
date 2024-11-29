# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYPI_PN="path.py"
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

MY_P="path.py-${PV}"

DESCRIPTION="A module wrapper for os.path"
HOMEPAGE="https://pypi.org/project/path.py/
		https://github.com/jaraco/path.py"
S="${WORKDIR}/${MY_P}"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~m68k ~mips ppc ppc64 ~s390 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/appdirs[${PYTHON_USEDEP}]
	!<dev-python/path-11.5.2-r200[${PYTHON_USEDEP}]
"
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}/path-py-11.5.2-tests.patch"
)

python_prepare_all() {
	# avoid a setuptools_scm dependency
	sed -i "s:use_scm_version=True:version='${PV}',name='${PN//-/.}':" setup.py || die
	sed -r -i "s:setuptools_scm[[:space:]]*([><=]{1,2}[[:space:]]*[0-9.a-zA-Z]+)[[:space:]]*::" \
		setup.cfg || die

	# disable flake8 tests
	sed -i -r 's: --flake8:: ; s: --black:: ; s: --cov::' \
		pytest.ini || die

	distutils-r1_python_prepare_all
}

python_test() {
	PYTHONPATH=. pytest -v || die
}
