# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module shell-completion

DESCRIPTION="declarative schema migrations with schema-as-code workflows"
HOMEPAGE="https://atlasgo.io/
		https://github.com/ariga/atlas"
SRC_URI="https://github.com/ariga/atlas/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test ) mirror network-sandbox"

BDEPEND="
	>=dev-lang/go-1.26.3:=
"

src_compile() {
	pushd cmd/atlas >/dev/null || die
	ego build -o atlas main.go
	popd >/dev/null || die
}

src_install() {
	dobin cmd/atlas/atlas

	cmd/atlas/atlas completion bash > "${PN}_completion.bash"
	newbashcomp "${PN}_completion.bash" "${PN}"

	cmd/atlas/atlas completion zsh > "${PN}_completion.zsh"
	newzshcomp "${PN}_completion.zsh" "_${PN}"
}

src_test() {
	mkdir "${HOME}/.cache" || die

	for test_dir in sql schemahcl cmd/atlas internal/integration/hclsqlspec; do
		pushd "${test_dir}" >/dev/null || die
		ego test ./...
		popd >/dev/null || die
	done
}
