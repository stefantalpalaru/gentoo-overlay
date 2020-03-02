# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )
EGO_PN=github.com/warner/${PN}

inherit distutils-r1

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/warner/magic-wormhole-mailbox-server.git"
	KEYWORDS=""
else
	KEYWORDS="~amd64"
	EGIT_COMMIT="${PV}"
	SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="Rendezvous / mailbox server for Magic-Wormhole"
HOMEPAGE="https://github.com/warner/magic-wormhole-mailbox-server"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=dev-python/attrs-16.3.0[${PYTHON_USEDEP}]
	>=dev-python/autobahn-0.14.1
	>=dev-python/twisted-17.5.0[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	virtual/python-futures[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_prepare(){
	# Dirty fix because twisted-tls is not recognised as a real dependency, but
	# we made sure pyOpenSSL, service_identity and idna are built anyway.
	sed -i -e '/twisted\[tls\]/d' setup.py || die "Sed failed!"
	eapply_user
}

python_install() {
	distutils-r1_python_install
	newinitd "${FILESDIR}/${PN}.init" "${PN}"
}
