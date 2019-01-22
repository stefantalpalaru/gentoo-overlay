# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-base

DESCRIPTION="Official golang implementation of the Ethereum protocol"
HOMEPAGE="https://github.com/ethereum/go-ethereum"
SRC_URI="https://github.com/ethereum/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+ LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="devtools"

DEPEND="
	dev-lang/go:=
"
RDEPEND="${DEPEND}"

# Does all kinds of wonky stuff like connecting to Docker daemon, network activity, ...
RESTRICT="test"

src_compile() {
	emake $(usex devtools all geth)
}

src_install() {
	einstalldocs

	dobin build/bin/geth
	if use devtools; then
		dobin build/bin/abigen
		dobin build/bin/bootnode
		dobin build/bin/evm
		dobin build/bin/p2psim
		dobin build/bin/puppeth
		dobin build/bin/rlpdump
		dobin build/bin/swarm
		dobin build/bin/wnode
	fi
}
