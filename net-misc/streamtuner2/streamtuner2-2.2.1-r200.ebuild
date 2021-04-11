# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit eutils

DESCRIPTION="internet radio browser"
HOMEPAGE="http://freshcode.club/projects/streamtuner2"
SRC_URI="mirror://sourceforge/${PN}/${P}.src.txz -> ${P}.tar.xz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/keybinder:0[python,python_targets_python2_7]
	dev-python/dbus-python:python2[python_targets_python2_7]
	dev-python/pillow:python2[python_targets_python2_7]
	|| ( dev-python/pygtk[python_targets_python2_7] dev-python/pygobject:3[python_targets_python2_7] )
	dev-python/pyquery:python2[python_targets_python2_7]
	dev-python/requests:python2[python_targets_python2_7]
	dev-python/pyxdg:python2[python_targets_python2_7]
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	default
	sed -i \
		-e "s/^VERSION :=.*$/VERSION := ${PV}/" \
		Makefile || die
	sed -i \
		-e 's#/usr/bin/env python#/usr/bin/env python2.7#' \
		st2.py bin || die
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
