# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Converts a Python dictionary or other data type to a valid XML string"
HOMEPAGE="https://github.com/quandyfactory/dicttoxml
		https://pypi.org/project/dicttoxml/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="python2"
KEYWORDS="amd64 x86"

RDEPEND="
	!<dev-python/dicttoxml-1.7.4-r3[${PYTHON_USEDEP}]
"
