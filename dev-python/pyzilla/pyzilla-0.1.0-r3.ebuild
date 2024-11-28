# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYPI_PN="PyZilla"
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Python wrapper for the BugZilla XML-RPC API"
HOMEPAGE="https://pypi.org/project/PyZilla/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
