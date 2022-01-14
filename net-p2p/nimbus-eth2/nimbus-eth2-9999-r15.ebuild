# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
EGIT_SUBMODULES=('*' '-vendor/nim-json-rpc')

inherit git-r3

DESCRIPTION="Nim implementation of the Ethereum 2.0 blockchain"
HOMEPAGE="https://github.com/status-im/nimbus-eth2"
EGIT_REPO_URI="https://github.com/status-im/nimbus-eth2.git"
EGIT_BRANCH="unstable"
RESTRICT="strip"

LICENSE="MIT-with-advertising Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="lto"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_compile() {
	NIMFLAGS="-d:disableMarchNative --passC:'${CFLAGS}' --passL:'${LDFLAGS}' -d:chronicles_sinks=textlines -d:chronicles_colors=none"
	if ! use lto; then
		NIMFLAGS="${NIMFLAGS} -d:disableLTO"
	else
		NIMFLAGS="${NIMFLAGS} --passL:'${CFLAGS}'"
	fi
	emake \
		OVERRIDE=1 \
		QUICK_AND_DIRTY_COMPILER=1 \
		update
	emake \
		LOG_LEVEL="TRACE" \
		NIMFLAGS="${NIMFLAGS}" \
		nimbus_beacon_node
}

src_install() {
	dobin build/nimbus_beacon_node

	newconfd "${FILESDIR}/${PN}.conf" ${PN}
	newinitd "${FILESDIR}/${PN}.init" ${PN}
	keepdir /var/log/${PN}

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate ${PN}

	dodoc "${FILESDIR}/prometheus.yml.example"
}
