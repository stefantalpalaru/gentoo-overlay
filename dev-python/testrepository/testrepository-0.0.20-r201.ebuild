# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 pypi

DESCRIPTION="A repository of test results"
HOMEPAGE="https://launchpad.net/testscenarios"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/python-subunit-0.0.18[${PYTHON_USEDEP}]
	>=dev-python/testtools-0.9.30:python2[${PYTHON_USEDEP}]
	dev-python/fixtures:python2[${PYTHON_USEDEP}]
	!<dev-python/testrepository-0.0.20-r200[${PYTHON_USEDEP}]
"
#bzr is listed but presumably req'd for a live repo test run

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		dev-python/testresources[${PYTHON_USEDEP}]
		dev-python/testscenarios[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
	)"

# Required for test phase
DISTUTILS_IN_SOURCE_BUILD=1

PATCHES=(
	"${FILESDIR}"/${P}-test-backport.patch
	"${FILESDIR}"/${P}-test-backport1.patch
	"${FILESDIR}"/${P}-test-backport2.patch
)

python_prepare_all() {
	mv testr testr_py2
	sed -i \
		-e 's/testr = testrepository.setuptools_command:Testr/testr_py2 = testrepository.setuptools_command:Testr/' \
		-e "s/scripts=\['testr'\]/scripts=\['testr_py2'\]/" \
		setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	# some errors appear to have crept in the suite undert py3 since addition.
	# Python2.7 now passes all.

	${PYTHON} testr init || die
	${PYTHON} testr run || die
}
