# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="CDDB"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="CDDB Module for Python"
HOMEPAGE="https://sourceforge.net/projects/cddb-py/"
SRC_URI="https://downloads.sourceforge.net/cddb-py/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc ppc64 sparc x86"
