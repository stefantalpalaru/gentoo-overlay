# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=${PN}-rally
MY_P=${MY_PN}-${PV}
DESCRIPTION="Free OpenGL rally car racing game"
HOMEPAGE="http://trigger-rally.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}/src

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-games/physfs
	dev-libs/tinyxml
	media-libs/freealut
	media-libs/libsdl[joystick]
	media-libs/openal
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-mixer
	virtual/glu
	virtual/opengl"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/trigger-0.6.6.1-default-config.patch
)

src_install() {
	emake DESTDIR="${ED}" prefix="/usr" bindir="/usr/bin" OPTIMS="" install
	mv "${ED}/usr/bin/trigger-rally" "${ED}/usr/bin/trigger"
}

pkg_postinst() {
	elog "After running trigger for the first time, a config file is"
	elog "available in ~/.local/share/trigger-rally/${MY_P}.config"
}
