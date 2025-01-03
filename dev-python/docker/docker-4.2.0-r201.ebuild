# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python client for Docker"
HOMEPAGE="https://github.com/docker/docker-py"
SRC_URI="https://github.com/docker/docker-py/archive/${PV}.tar.gz -> ${PN}-py.${PV}.gh.tar.gz"
S="${WORKDIR}/docker-py-${PV}"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	!~dev-python/requests-2.18.0:python2[${PYTHON_USEDEP}]
	>=dev-python/requests-2.14.2:python2[${PYTHON_USEDEP}]
	>=dev-python/six-1.4.0:python2[${PYTHON_USEDEP}]
	>=dev-python/websocket-client-0.32.0:python2[${PYTHON_USEDEP}]
	>=dev-python/backports-ssl-match-hostname-3.5[${PYTHON_USEDEP}]
	>=dev-python/ipaddress-1.0.16[${PYTHON_USEDEP}]
	!<dev-python/docker-4.2.0-r3[${PYTHON_USEDEP}]
"
DEPEND="
	test? (
		${RDEPEND}
		>=dev-python/mock-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/paramiko-2.4.2[${PYTHON_USEDEP}]
		dev-python/pytest-runner[${PYTHON_USEDEP}]
		>=dev-python/pytest-2.9.1[${PYTHON_USEDEP}]
	)
	doc? (
		dev-python/recommonmark[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.4.6[${PYTHON_USEDEP}]
	)
"

python_compile_all() {
	if use doc; then
		sphinx-build docs html || die "docs failed to build"
		HTML_DOCS=( html/. )
	fi
}

python_test() {
	py.test tests/unit/ || die "tests failed under ${EPYTHON}"
}
