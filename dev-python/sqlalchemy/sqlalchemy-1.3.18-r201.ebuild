# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite?"
MY_PN="SQLAlchemy"
MY_P="${MY_PN}-${PV/_beta/b}"
PYPI_NO_NORMALIZE=1
PYPI_PN="${MY_PN}"
DISTUTILS_EXT=1

inherit distutils-r1 flag-o-matic optfeature pypi

DESCRIPTION="Python SQL toolkit and Object Relational Mapper"
HOMEPAGE="https://www.sqlalchemy.org/
			https://pypi.org/project/SQLAlchemy/"
S="${WORKDIR}/${MY_P}"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="examples +sqlite"
RESTRICT="mirror test"

RDEPEND="
	!<dev-python/sqlalchemy-1.3.18-r200[${PYTHON_USEDEP}]
"

distutils_enable_sphinx doc

python_prepare_all() {
	# Disable tests hardcoding function call counts specific to Python versions.
	rm -r test/aaa_profiling || die
	distutils-r1_python_prepare_all
}

python_compile() {
	if ! python_is_python3; then
		local CFLAGS=${CFLAGS}
		append-cflags -fno-strict-aliasing
	fi
	distutils-r1_python_compile
}

python_install_all() {
	use examples && dodoc -r examples

	distutils-r1_python_install_all
}

pkg_postinst() {
	optfeature "MySQL support" dev-python/mysql-python dev-python/mysql-connector-python
	optfeature "mssql support" dev-python/pymssql
	optfeature "postgresql support" dev-python/psycopg:2
}
