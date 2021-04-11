# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="Flask-Evolution"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Simple migrations for Flask/SQLAlchemy projects"
HOMEPAGE="https://pypi.org/project/Flask-Evolution/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools:python2[${PYTHON_USEDEP}]
	dev-python/flask:python2[${PYTHON_USEDEP}]
	dev-python/flask-sqlalchemy:python2[${PYTHON_USEDEP}]
	dev-python/flask-script:python2[${PYTHON_USEDEP}]
	!<dev-python/flask-evolution-0.6-r200[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"
