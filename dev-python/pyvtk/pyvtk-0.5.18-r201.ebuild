# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Tools for manipulating VTK files in Python"
HOMEPAGE="http://cens.ioc.ee/projects/pyvtk/"
SRC_URI="https://files.pythonhosted.org/packages/6a/dc/d5ffc2cc50bdd7a2e7b435655ee5931d614f7c118624dd20c51440c79337/PyVTK-${PV}.tar.gz"
S="${WORKDIR}/PyVTK-${PV}"
LICENSE="LGPL-2.1"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror test"

RDEPEND="
	!<dev-python/pyvtk-0.5.18-r200[${PYTHON_USEDEP}]
"
