# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python library to work with pdf files"
HOMEPAGE="http://pybrary.net/pyPdf/ https://pypi.org/project/pyPdf/"
SRC_URI="http://pybrary.net/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"
