# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
DISTUTILS_EXT=1

inherit distutils-r1

DESCRIPTION="Control process attributes through prctl"
HOMEPAGE="https://github.com/seveas/python-prctl"
SRC_URI="https://github.com/seveas/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror test"

RDEPEND="sys-libs/libcap"
DEPEND="${RDEPEND}"
