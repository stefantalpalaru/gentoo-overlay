# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="Pyndex"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Simple and fast Python full-text indexer using Metakit as its back-end"
HOMEPAGE="https://sourceforge.net/projects/pyndex/"
SRC_URI="https://downloads.sourceforge.net/pyndex/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="test"

RDEPEND=">=dev-db/metakit-2.4.9.2[python]"
