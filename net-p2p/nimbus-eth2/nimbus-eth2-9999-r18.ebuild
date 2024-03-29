# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Nim implementation of the Ethereum 2.0 blockchain"
HOMEPAGE="https://github.com/status-im/nimbus-eth2"
EGIT_REPO_URI="https://github.com/status-im/nimbus-eth2.git"
EGIT_BRANCH="unstable"

# Upstream fucked up and pointed a Git submodule to a dangling commit: https://github.com/status-im/Nim/commit/7f90bcf5b4cbe5b7da534dd79bafbb4cafb313fa
# so we disable Portage's submodule retrieval because it cannot deal with that.
#EGIT_SUBMODULES=('*' '-vendor/nim-json-rpc')
EGIT_SUBMODULES=()

LICENSE="MIT-with-advertising Apache-2.0"
SLOT="0"
IUSE="lto"
RESTRICT="strip network-sandbox"

BDEPEND="
	dev-vcs/git-lfs
"

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
