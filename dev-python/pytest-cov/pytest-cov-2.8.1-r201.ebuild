# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="py.test plugin for coverage reporting"
HOMEPAGE="https://github.com/pytest-dev/pytest-cov
		https://pypi.org/project/pytest-cov/"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~mips ppc ppc64 s390 sparc x86"
IUSE="test"
RESTRICT="mirror !test? ( test )"

RDEPEND="
	>=dev-python/py-1.4.22[${PYTHON_USEDEP}]
	>=dev-python/pytest-3.6[${PYTHON_USEDEP}]
	>=dev-python/coverage-4.4[${PYTHON_USEDEP}]
	!<dev-python/pytest-cov-2.8.1-r200[${PYTHON_USEDEP}]
"
DEPEND="
	test? (
		dev-python/virtualenv[${PYTHON_USEDEP}]
		dev-python/fields[${PYTHON_USEDEP}]
		>=dev-python/process-tests-2.0.2[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	# Bug 597708
	"${FILESDIR}/${PN}-2.8.1-disable-broken-tests.patch"
	"${FILESDIR}/${PN}-2.8.1-latest-setuptools.patch"
	# https://github.com/pytest-dev/pytest-cov/issues/365
	"${FILESDIR}/pytest-cov-2.8.1-python38.patch"
)

python_test() {
	distutils_install_for_testing
	PYTHONPATH="${S}/tests:${BUILD_DIR}/lib:${PYTHONPATH}" \
		PYTEST_PLUGINS=${PN/-/_} \
		pytest -vv || die "Tests failed under ${EPYTHON}"
}
