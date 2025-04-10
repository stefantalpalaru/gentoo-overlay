# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1
PYPI_PN=Flask-Evolution

inherit distutils-r1 pypi

MY_PN="Flask-Evolution"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Simple migrations for Flask/SQLAlchemy projects"
HOMEPAGE="https://pypi.org/project/Flask-Evolution/"
S="${WORKDIR}/${MY_P}"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

DEPEND="dev-python/setuptools:python2[${PYTHON_USEDEP}]
	dev-python/flask:python2[${PYTHON_USEDEP}]
	dev-python/flask-sqlalchemy:python2[${PYTHON_USEDEP}]
	dev-python/flask-script:python2[${PYTHON_USEDEP}]
	!<dev-python/flask-evolution-0.6-r200[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
