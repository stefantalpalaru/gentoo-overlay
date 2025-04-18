# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
MY_PN="lib_rharris"
MY_P="${MY_PN}-${PV}"
PYPI_PN="${MY_PN}"

inherit distutils-r1 pypi

DESCRIPTION="Python Internet Programming Library"
HOMEPAGE="https://pypi.org/project/lib_rharris/"
S="${WORKDIR}/${MY_P}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="mirror"
