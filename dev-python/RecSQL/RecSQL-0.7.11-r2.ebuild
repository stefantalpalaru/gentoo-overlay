# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1 vcs-snapshot

SRC_URI="https://github.com/orbeckst/${PN}/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
DESCRIPTION="Simple SQL analysis of python records"
HOMEPAGE="https://orbeckst.github.com/RecSQL/"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="dev-python/numpy-python2[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

RESTRICT="test"
