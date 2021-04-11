# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
EGO_PN=github.com/warner/${PN}

inherit distutils-r1

KEYWORDS="~amd64"
EGIT_COMMIT="${PV}"
SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
DESCRIPTION="Rendezvous / mailbox server for Magic-Wormhole"
HOMEPAGE="https://github.com/warner/magic-wormhole-mailbox-server"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="test"

RDEPEND=">=dev-python/attrs-16.3.0:python2[${PYTHON_USEDEP}]
	>=dev-python/autobahn-0.14.1:python2[${PYTHON_USEDEP}]
	>=dev-python/twisted-17.5.0:python2[${PYTHON_USEDEP}]
	dev-python/pyopenssl:python2[${PYTHON_USEDEP}]
	dev-python/six:python2[${PYTHON_USEDEP}]
	virtual/python-futures[${PYTHON_USEDEP}]
	!<dev-python/magic-wormhole-mailbox-server-0.4.1-r200[${PYTHON_USEDEP}]
"
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
