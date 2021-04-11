# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit eutils

DESCRIPTION="internet radio browser"
HOMEPAGE="http://freshcode.club/projects/streamtuner2"
SRC_URI="mirror://sourceforge/${PN}/${P}.src.txz -> ${P}.tar.xz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/keybinder[python]
	dev-python/dbus-python
	dev-python/pillow
	|| ( dev-python/pygtk dev-python/pygobject:3 )
	dev-python/pyquery
	dev-python/requests
	dev-python/pyxdg"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	sed -i -e "s/^VERSION :=.*$/VERSION := ${PV}/" Makefile
	gunzip -k gtk3.xml.gz
}

src_install() {
	exeinto /usr/bin
	newexe bin st2.py
	dosym st2.py /usr/bin/${PN}

	insinto /usr/share/pixmaps
	doins streamtuner2.png

	dodir /usr/share/${PN}
	cp -R . "${D}/usr/share/${PN}"
}
