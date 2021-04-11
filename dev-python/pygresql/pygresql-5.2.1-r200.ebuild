# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

POSTGRES_COMPAT=( 9.6 {10..14} )
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 postgres

MY_P="PyGreSQL-${PV}"

DESCRIPTION="A Python interface for the PostgreSQL database"
HOMEPAGE="http://www.pygresql.org/"
SRC_URI="mirror://pypi/P/PyGreSQL/${MY_P}.tar.gz"

LICENSE="POSTGRESQL"
SLOT="python2"
KEYWORDS="alpha amd64 ~hppa ia64 ppc sparc x86"
IUSE=""
RESTRICT="test"

REQUIRED_USE="${POSTGRES_REQ_USE}"

DEPEND="${POSTGRES_DEP}"

RDEPEND="${DEPEND}
	!<dev-python/pygresql-5.2.1-r200[${PYTHON_USEDEP}]
"

S="${WORKDIR}/${MY_P}"

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
