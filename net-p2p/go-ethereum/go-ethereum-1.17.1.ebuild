# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Official golang implementation of the Ethereum protocol"
HOMEPAGE="https://github.com/ethereum/go-ethereum"
SRC_URI="https://github.com/ethereum/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3+ LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="devtools"
# Tests do all kinds of wonky stuff like connecting to Docker daemon, network activity, etc.
RESTRICT="mirror network-sandbox test"
QA_PRESTRIPPED="/usr/bin/workload /usr/bin/geth-ethkey /usr/bin/geth /usr/bin/evm /usr/bin/era /usr/bin/devp2p /usr/bin/clef /usr/bin/blsync /usr/bin/abigen /usr/bin/abidump"

DEPEND="
	>=dev-lang/go-1.24:=
"
RDEPEND="${DEPEND}"

src_compile() {
	emake $(usex devtools all geth)
}

src_install() {
	einstalldocs

	dobin build/bin/geth
	if use devtools; then
		mv build/bin/ethkey build/bin/geth-ethkey # collision with net-p2p/parity::chaoslab
		for F in build/bin/*; do
			if [[ "${F}" == "build/bin/examples" ]]; then
				continue
			fi
			dobin "${F}"
		done
	fi
}
