# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Extensions to the standard Python datetime module"
HOMEPAGE="
	https://dateutil.readthedocs.org/
	https://pypi.org/project/python-dateutil
	https://github.com/dateutil/dateutil/
"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
RESTRICT="test"

RDEPEND="
	>=dev-python/six-1.5[${PYTHON_USEDEP}]
	sys-libs/timezone-data
	!<dev-python/python-dateutil-2.8.1-r200[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/0001-zoneinfo-Get-timezone-data-from-system-tzdata-r1.patch"
	"${FILESDIR}/python-dateutil-2.8.1-no-pytest-cov.patch"
)

python_prepare_all() {
	# don't install zoneinfo tarball
	sed -i '/package_data=/d' setup.py || die

	distutils-r1_python_prepare_all
}

python_prepare() {
	if [[ ${EPYTHON} == python3.7 ]]; then
		# these tests are flakey on 3.7
		rm dateutil/test/property/test_{parser,isoparse}_prop.py || die
	fi
}
