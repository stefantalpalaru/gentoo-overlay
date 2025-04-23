# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
MY_PN="${PN}2"
MY_P="${MY_PN}-${PV}"
PYPI_PN="${MY_PN}"
DISTUTILS_EXT=1

inherit distutils-r1 flag-o-matic pypi

DESCRIPTION="PostgreSQL database adapter for Python"
HOMEPAGE="https://www.psycopg.org
		https://pypi.org/project/psycopg2/
		https://github.com/psycopg/psycopg2"
S=${WORKDIR}/${MY_P}
LICENSE="LGPL-3+"
SLOT="python2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="debug test"
RESTRICT="mirror !test? ( test )"

# automagic dep on mxdatetime (from egenix-mx-base)
# the package was removed, so let's just make sure it's gone
RDEPEND=">=dev-db/postgresql-8.1:*"
DEPEND="${RDEPEND}
	test? ( >=dev-db/postgresql-8.1[server] )
	!!dev-python/egenix-mx-base
	!<dev-python/psycopg-2.8.6-r200[${PYTHON_USEDEP}]
"

python_compile() {
	local CFLAGS=${CFLAGS} CXXFLAGS=${CXXFLAGS}

	append-flags -fno-strict-aliasing

	distutils-r1_python_compile
}

python_prepare_all() {
	if use debug; then
		sed -i 's/^\(define=\)/\1PSYCOPG_DEBUG,/' setup.cfg || die
	fi

	distutils-r1_python_prepare_all
}

src_test() {
	initdb -D "${T}"/pgsql || die
	# TODO: random port
	pg_ctl -w -D "${T}"/pgsql start \
		-o "-h '' -k '${T}'" || die
	createdb -h "${T}" psycopg2_test || die

	local -x PSYCOPG2_TESTDB_HOST="${T}"
	distutils-r1_src_test

	pg_ctl -w -D "${T}"/pgsql stop || die
}

python_test() {
	"${EPYTHON}" -c "
import tests
tests.unittest.main(defaultTest='tests.test_suite')
" --verbose || die "Tests fail with ${EPYTHON}"
}
