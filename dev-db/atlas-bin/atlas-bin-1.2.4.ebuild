# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
# wget https://atlasbinaries.com/atlas/atlas-linux-amd64-latest
# chmod 755 atlas-linux-amd64-latest
# ./atlas-linux-amd64-latest version
MY_EXTRA_VERSION="0e75495-canary"

inherit shell-completion

DESCRIPTION="declarative schema migrations - binary package"
HOMEPAGE="https://atlasgo.io/"
SRC_URI="
	amd64? ( https://atlasbinaries.com/atlas/atlas-linux-amd64-v${PV}-${MY_EXTRA_VERSION} )
	arm64? ( https://atlasbinaries.com/atlas/atlas-linux-arm64-v${PV}-${MY_EXTRA_VERSION} )
"
LICENSE="Atlas-EULA"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="mirror"

src_unpack() {
	mkdir -p "${S}" || die "Can't mkdir ${S}"
	cd "${S}"	|| die "Can't enter ${S}"
	for file in ${A}; do
		einfo "Copying ${file}"
		cp "${DISTDIR}/${file}" "${S}/" || die "Can't copy ${file}"
	done
}

src_install() {
	newbin atlas-* atlas-bin

	"${ED}/usr/bin/atlas-bin" completion bash > "${PN}_completion.bash" || die
	sed -i \
		-e 's/atlas/atlas-bin/g' \
		"${PN}_completion.bash" || die
	newbashcomp "${PN}_completion.bash" "${PN}"

	"${ED}/usr/bin/atlas-bin" completion zsh > "${PN}_completion.zsh" || die
	sed -i \
		-e 's/atlas/atlas-bin/g' \
		"${PN}_completion.zsh" || die
	newzshcomp "${PN}_completion.zsh" "_${PN}"
}
