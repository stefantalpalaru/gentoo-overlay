# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 flag-o-matic xdg

MY_PN="DisplayCAL"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Display calibration and characterization powered by Argyll CMS"
HOMEPAGE="https://displaycal.net/"
SRC_URI="https://downloads.sourceforge.net/dispcalgui/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=media-gfx/argyllcms-1.1.0
	dev-python/wxpython[${PYTHON_USEDEP}]
	>=x11-libs/libX11-1.3.3
	>=x11-apps/xrandr-1.3.2
	>=x11-libs/libXxf86vm-1.1.0
	>=x11-libs/libXinerama-1.1
"
RDEPEND="${DEPEND}
	dev-python/faulthandler[${PYTHON_USEDEP}]
	dev-python/numpy-python2[${PYTHON_USEDEP}]
	|| (
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/dbus-python[${PYTHON_USEDEP}]
	)
"

src_prepare() {
	# Do not generate udev/hotplug files
	sed -e '/if os.path.isdir/s#/etc/udev/rules.d\|/etc/hotplug#\0-non-existant#' \
		-i DisplayCAL/setup.py || die
	# Prohibit setup from running xdg-* programs, resulting to sandbox violation
	sed -e '/if which/s#xdg-icon-resource#\0-non-existant#' \
		-e '/if which/s#xdg-desktop-menu#\0-non-existant#' \
		-i DisplayCAL/postinstall.py || die

	# Remove deprecated Encoding key from .desktop file
	sed -e '/Encoding=UTF-8/d' -i misc/*.desktop  || die

	# Remove x-world Media Type
	sed -e 's/x\-world\/x\-vrml\;//g' \
		-i misc/displaycal-vrml-to-x3d-converter.desktop || die

	append-cflags -fpermissive

	distutils-r1_src_prepare
}

pkg_postinst() {
	xdg_pkg_postinst
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_pkg_postrm
	xdg_icon_cache_update
}
