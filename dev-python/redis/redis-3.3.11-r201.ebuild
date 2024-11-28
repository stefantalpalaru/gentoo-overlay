# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Python client for Redis key-value store"
HOMEPAGE="https://github.com/andymccurdy/redis-py"
SRC_URI="$(pypi_sdist_url) -> ${PN}-py.${PV}.tar.gz"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	!!<=dev-python/redis-3.3.11-r1[${PYTHON_USEDEP}]
"
DEPEND="test? (
		dev-db/redis
		dev-python/mock[${PYTHON_USEDEP}]
		>=dev-python/pytest-2.7.0[${PYTHON_USEDEP}] )"

python_prepare_all() {
	distutils-r1_python_prepare_all

	# Make sure that tests will be used from BUILD_DIR rather than cwd.
	mv tests tests-hidden || die

	# Correct local import patch syntax
	sed \
		-e 's:from .conftest:from conftest:' \
		-e 's:from .test_pubsub:from test_pubsub:' \
		-i tests-hidden/test_*.py \
		|| die
}

python_compile() {
	distutils-r1_python_compile

	if use test; then
		cp -r tests-hidden "${BUILD_DIR}"/tests || die
	fi
}

python_test() {
	local sock="${T}/redis.sock"

	"${EPREFIX}/usr/sbin/redis-server" - <<- EOF
		daemonize yes
		pidfile "${T}/redis.pid"
		unixsocket ${sock}
		EOF

	PYTHONPATH="${S}:${S}/tests-hidden"
	esetup.py test --verbose
	kill $(<"${T}/redis.pid")
}
