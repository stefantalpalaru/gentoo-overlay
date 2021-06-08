# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Decode OOK modulated signals"
HOMEPAGE="https://github.com/merbanan/rtl_433"
SRC_URI="https://github.com/merbanan/rtl_433/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-2"
SLOT="0"
IUSE="+rtlsdr soapysdr"

DEPEND="rtlsdr? ( net-wireless/rtl-sdr:=
			virtual/libusb:1 )
	soapysdr? ( net-wireless/soapysdr:= )"
RDEPEND="${DEPEND}"

src_configure() {
	mycmakeargs=(
		-DBUILD_TESTING=OFF
		-DENABLE_RTLSDR="$(usex rtlsdr)"
		-DENABLE_SOAPYSDR="$(usex soapysdr)"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	mv "${ED}/usr/etc" "${ED}/" || die
}
