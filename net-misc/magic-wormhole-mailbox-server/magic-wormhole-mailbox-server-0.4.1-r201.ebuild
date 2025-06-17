# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
EGIT_COMMIT="${PV}"

inherit distutils-r1

DESCRIPTION="Rendezvous / mailbox server for Magic-Wormhole"
HOMEPAGE="https://github.com/warner/magic-wormhole-mailbox-server"
SRC_URI="https://github.com/warner/magic-wormhole-mailbox-server/archive/${EGIT_COMMIT}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64"
RESTRICT="mirror test"

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
