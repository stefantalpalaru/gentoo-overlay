# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
NONFATAL_VERIFY=1

inherit go-module

DESCRIPTION="ctags-compatible tag generator for Go"
HOMEPAGE="https://github.com/jstemmer/gotags"
SRC_URI="https://github.com/jstemmer/gotags/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT+="mirror"

PATCHES=(
	"${FILESDIR}"/gotags-1.4.1-module.patch
)

src_compile() {
	ego build -o ${PN}
}

src_install() {
	dobin ${PN}

	DOCS=( README.md )
	einstalldocs
}
