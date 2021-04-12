# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A minimal set of Python bindings for libirman"
HOMEPAGE="http://bluweb.com/chouser/proj/irman-python/"
SRC_URI="http://bluweb.com/chouser/proj/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-libs/libirman"
RDEPEND="${DEPEND}"
DOCS=( README test_name.py )
