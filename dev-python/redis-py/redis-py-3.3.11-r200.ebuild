# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="redis"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python client for Redis key-value store"
HOMEPAGE="https://github.com/andymccurdy/redis-py"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	!!<=dev-python/redis-py-3.3.11-r1[${PYTHON_USEDEP}]
"
DEPEND="test? (
		dev-db/redis
		dev-python/mock[${PYTHON_USEDEP}]
		>=dev-python/pytest-2.7.0[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_P}"

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
