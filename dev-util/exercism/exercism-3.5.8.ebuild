# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module shell-completion

DESCRIPTION="Command line client for https://exercism.io"
HOMEPAGE="
	https://exercism.org
	https://github.com/exercism/cli
"

SRC_URI="https://github.com/${PN}/cli/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/cli-${PV}"
LICENSE="MIT Apache-2.0 BSD-2 BSD MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="network-sandbox test"

RDEPEND="sys-libs/glibc"
BDEPEND="dev-lang/go"

src_compile() {
	ego build -o out/exercism exercism/main.go
}

src_install() {
	default
	dobin out/exercism
	# bash-completion
	newbashcomp "shell/${PN}_completion.bash" "${PN}"
	# zsh-completion
	newzshcomp "shell/${PN}_completion.zsh" "_${PN}"
}
