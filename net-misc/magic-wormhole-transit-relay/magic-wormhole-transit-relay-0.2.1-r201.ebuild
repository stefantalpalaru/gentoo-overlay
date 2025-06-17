# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
EGIT_COMMIT="${PV}"

inherit distutils-r1

DESCRIPTION="Transit Relay server for Magic-Wormhole"
HOMEPAGE="https://github.com/warner/magic-wormhole-transit-relay"
SRC_URI="https://github.com/warner/magic-wormhole-transit-relay/archive/${EGIT_COMMIT}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64"
RESTRICT="mirror test"

RDEPEND="
	>=dev-python/twisted-17.5.0:python2[${PYTHON_USEDEP}]
	virtual/python-futures[${PYTHON_USEDEP}]
	!<dev-python/magic-wormhole-transit-relay-0.2.1-r200[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

python_install() {
	distutils-r1_python_install
	newinitd "${FILESDIR}/${PN}.init" "${PN}"
}
