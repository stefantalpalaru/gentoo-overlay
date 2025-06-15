# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Utility for mocking out the Python Requests library"
HOMEPAGE="https://github.com/getsentry/responses"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror test"

RDEPEND="
	>=dev-python/requests-2.0[${PYTHON_USEDEP}]
	dev-python/cookies[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	!<dev-python/responses-0.10.7-r200[${PYTHON_USEDEP}]
"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/responses-0.10.7-fix-cookies.patch"
	"${FILESDIR}/responses-0.10.7-tests.patch"
)
