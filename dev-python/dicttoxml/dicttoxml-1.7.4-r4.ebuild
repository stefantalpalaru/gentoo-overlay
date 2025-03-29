# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Converts a Python dictionary or other data type to a valid XML string"
HOMEPAGE="https://github.com/quandyfactory/dicttoxml
		https://pypi.org/project/dicttoxml/"
LICENSE="GPL-2"
SLOT="python2"
KEYWORDS="amd64 x86"
RESTRICT="mirror"

RDEPEND="
	!<dev-python/dicttoxml-1.7.4-r3[${PYTHON_USEDEP}]
"
