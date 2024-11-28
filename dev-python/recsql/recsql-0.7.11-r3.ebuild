# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Simple SQL analysis of python records"
HOMEPAGE="https://orbeckst.github.com/RecSQL/"
SRC_URI="https://github.com/orbeckst/RecSQL/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/numpy:python2[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

RESTRICT="test"
