# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Nim implementation of the Ethereum 2.0 blockchain"
HOMEPAGE="https://github.com/status-im/nimbus-eth2"
EGIT_REPO_URI="https://github.com/status-im/nimbus-eth2.git"
EGIT_BRANCH="devel"
RESTRICT="strip"

LICENSE="MIT-with-advertising Apache-2.0"
SLOT="0"
KEYWORDS=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_compile() {
	emake LOG_LEVEL="TRACE" NIMFLAGS="-d:insecure -d:disableMarchNative --passC:'${CFLAGS}' --passL:'${LDFLAGS}'" \
		beacon_node beacon_node_spec_0_12_3 #signing_process
}

src_install() {
	newbin build/beacon_node nimbus_beacon_node
	newbin build/beacon_node_spec_0_12_3 nimbus_beacon_node_medalla
	#newbin build/signing_process nimbus_signing_process

	newconfd "${FILESDIR}/${PN}.conf" ${PN}
	newinitd "${FILESDIR}/${PN}.init" ${PN}

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate ${PN}

	dodoc "${FILESDIR}/prometheus.yml.example"
}
