# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Google API Client for Python"
HOMEPAGE="https://github.com/google/google-api-python-client"
SRC_URI="https://github.com/google/google-api-python-client/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/chardet:python2[${PYTHON_USEDEP}]
	>=dev-python/httplib2-0.9.2:python2[${PYTHON_USEDEP}]
	<dev-python/httplib2-1:python2[${PYTHON_USEDEP}]
	dev-python/setuptools:python2[${PYTHON_USEDEP}]
	dev-python/google-api-core:python2[${PYTHON_USEDEP}]
	>=dev-python/google-auth-1.4.1:python2[${PYTHON_USEDEP}]
	>=dev-python/google-auth-httplib2-0.0.3:python2[${PYTHON_USEDEP}]
	>=dev-python/uritemplate-3.0:python2[${PYTHON_USEDEP}]
	<dev-python/uritemplate-4:python2[${PYTHON_USEDEP}]
	>=dev-python/six-1.6.1:python2[${PYTHON_USEDEP}]
	<dev-python/six-2:python2[${PYTHON_USEDEP}]
	!<dev-python/google-api-python-client-1.8.4-r2[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		dev-python/google-auth-httplib2[${PYTHON_USEDEP}]
		dev-python/oauth2client[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/unittest2[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}/google-api-python-client-1.8.3-tests.patch"
)

python_test() {
	distutils_install_for_testing
	pytest -vv || die "tests fail with ${EPYTHON}"
}
