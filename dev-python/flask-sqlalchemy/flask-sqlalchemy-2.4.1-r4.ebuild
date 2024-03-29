# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="Flask-SQLAlchemy"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="SQLAlchemy support for Flask applications"
HOMEPAGE="https://pypi.org/project/Flask-SQLAlchemy/
		https://github.com/pallets/flask-sqlalchemy"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 x86"

RDEPEND="
	>=dev-python/flask-0.10[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-0.8.0[${PYTHON_USEDEP}]
	!<dev-python/flask-sqlalchemy-2.4.1-r4[${PYTHON_USEDEP}]
"
distutils_enable_sphinx docs dev-python/pallets-sphinx-themes \
	dev-python/sphinx-issues

S="${WORKDIR}/${MY_P}"
