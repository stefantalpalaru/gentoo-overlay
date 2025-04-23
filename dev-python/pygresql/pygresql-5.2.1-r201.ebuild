# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
POSTGRES_COMPAT=( {13..17} )
PYTHON_COMPAT=( python2_7 )
MY_P="PyGreSQL-${PV}"
PYPI_NO_NORMALIZE=1
PYPI_PN=PyGreSQL
DISTUTILS_EXT=1

inherit distutils-r1 postgres pypi

DESCRIPTION="A Python interface for the PostgreSQL database"
HOMEPAGE="http://www.pygresql.org/"
S="${WORKDIR}/${MY_P}"
LICENSE="POSTGRESQL"
SLOT="python2"
KEYWORDS="alpha amd64 ~hppa ppc sparc x86"
RESTRICT="mirror test"

REQUIRED_USE="${POSTGRES_REQ_USE}"

DEPEND="${POSTGRES_DEP}"

RDEPEND="${DEPEND}
	!<dev-python/pygresql-5.2.1-r200[${PYTHON_USEDEP}]
"

src_prepare() {
	default
	sed -i -e "s/, '-Werror'//" \
		-e "s/'-O2', //" \
		setup.py
}

python_install_all() {
	local DOCS=( docs/*.rst docs/community/* docs/contents/tutorial.rst )

	distutils-r1_python_install_all
}
