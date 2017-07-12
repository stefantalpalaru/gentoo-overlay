# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="A fork of nicotine, a Soulseek client in Python"
HOMEPAGE="https://www.nicotine-plus.org/"
SRC_URI="https://github.com/Nicotine-Plus/nicotine-plus/archive/1.4.1.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="
	>=dev-python/pygtk-2.24[${PYTHON_USEDEP}]
	media-libs/mutagen
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/nicotine-plus-${PV}"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	distutils-r1_src_prepare
	sed -i -e 's:\(Icon=\).*:\1nicotine-plus-32px:' \
		"${S}"/files/nicotine.desktop
	default
}

src_install() {
	distutils-r1_src_install
	python_fix_shebang "${D}"
}

pkg_postinst() {
	echo
	elog "You may want to install these packages to add additional features"
	elog "to Nicotine+:"
	elog
	elog "dev-python/geoip-python         Country lookup and flag display"
	elog "dev-python/notify-python        Notification support"
	elog "net-libs/miniupnpc              UPnP portmapping"
	echo
}
