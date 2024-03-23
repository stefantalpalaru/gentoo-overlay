# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2

DESCRIPTION="Tool to create garmin maps"
HOMEPAGE="http://www.mkgmap.org.uk"
MY_PN=${PN%-bin}
SRC_URI="http://www.mkgmap.org.uk/download/${MY_PN}-r${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-r${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jre-1.8
	!sci-geosciences/mkgmap"

src_compile() {
	:
}

src_install() {
	java-pkg_dojar "${MY_PN}.jar"
	java-pkg_jarinto "/usr/share/${PN}/lib/lib"
	java-pkg_dojar lib/*.jar
	java-pkg_dolauncher "${MY_PN}" --jar "${MY_PN}.jar" || die "java-pkg_dolauncher failed"

	doman doc/mkgmap.1
}
