# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python package to parse, read and write Microsoft OLE2 files"
HOMEPAGE="https://www.decalage.info/olefile"
SRC_URI="https://github.com/decalage2/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="BSD-2"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror test"

distutils_enable_sphinx doc

RDEPEND="
	!<dev-python/olefile-0.46-r200[${PYTHON_USEDEP}]
"
