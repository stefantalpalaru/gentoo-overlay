# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="CDDB"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="CDDB Module for Python"
HOMEPAGE="https://sourceforge.net/projects/cddb-py/"
SRC_URI="mirror://sourceforge/cddb-py/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc ppc64 sparc x86"
IUSE=""

S="${WORKDIR}/${MY_P}"
