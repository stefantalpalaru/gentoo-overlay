# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE=sqlite

inherit distutils-r1 pypi

DESCRIPTION="Stack based utility with CLI interface helping to monitor time spent on tasks"
HOMEPAGE="https://github.com/yaccz/worklog"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/sqlalchemy
	dev-python/cement[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/alembic[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
