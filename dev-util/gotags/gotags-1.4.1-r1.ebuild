# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN=github.com/jstemmer/gotags
inherit golang-build

DESCRIPTION="ctags-compatible tag generator for Go"
HOMEPAGE="https://${EGO_PN}"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_unpack() {
	unpack ${A}
	mkdir -p "${S}/src/${EGO_PN%/*}" || die
	ln -s "${S}" "${S}/src/${EGO_PN}" || die
}

src_install() {
	dobin ${PN}

	DOCS=( src/${EGO_PN}/README.md )
	einstalldocs
}
