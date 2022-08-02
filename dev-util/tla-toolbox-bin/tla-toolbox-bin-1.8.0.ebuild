# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
MY_PN="tla-toolbox"

DESCRIPTION="IDE for TLA+"
HOMEPAGE="https://lamport.azurewebsites.net/tla/toolbox.html
	https://github.com/tlaplus/tlaplus"
SRC_URI="https://github.com/tlaplus/tlaplus/releases/download/v${PV}/TLAToolbox-${PV}-linux.gtk.x86_64.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}
	x11-libs/gtk+:3
"
BDEPEND="app-arch/unzip"

S="${WORKDIR}/toolbox"

src_install() {
	dodir "/opt/${MY_PN}"
	cp -a * "${ED}/opt/${MY_PN}" || die
	dosym "../../opt/${MY_PN}/toolbox" "/usr/bin/${MY_PN}"
}
