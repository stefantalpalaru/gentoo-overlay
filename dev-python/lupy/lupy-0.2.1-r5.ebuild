# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="Lupy"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Lupy is a is a full-text indexer and search engine written in Python"
HOMEPAGE="https://pypi.org/project/Lupy/"
SRC_URI="https://downloads.sourceforge.net/lupy/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc ~s390 x86"
IUSE="examples"
RESTRICT="mirror"

DOCS="changelog.txt releasenotes.txt"

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
