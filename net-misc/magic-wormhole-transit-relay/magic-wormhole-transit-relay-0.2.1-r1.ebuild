# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )
EGO_PN=github.com/warner/${PN}

inherit distutils-r1

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/warner/magic-wormhole-transit-relay.git"
	KEYWORDS=""
else
	KEYWORDS="~amd64"
	EGIT_COMMIT="${PV}"
	SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="Transit Relay server for Magic-Wormhole"
HOMEPAGE="https://github.com/warner/magic-wormhole-transit-relay"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	>=dev-python/twisted-17.5.0[${PYTHON_USEDEP}]
	virtual/python-futures[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

python_install() {
	distutils-r1_python_install
	newinitd "${FILESDIR}/${PN}.init" "${PN}"
}
