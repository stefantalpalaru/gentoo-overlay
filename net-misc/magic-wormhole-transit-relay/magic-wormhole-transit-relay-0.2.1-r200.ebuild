# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
EGO_PN=github.com/warner/${PN}

inherit distutils-r1

KEYWORDS="~amd64"
EGIT_COMMIT="${PV}"
SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
DESCRIPTION="Transit Relay server for Magic-Wormhole"
HOMEPAGE="https://github.com/warner/magic-wormhole-transit-relay"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="test"

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
