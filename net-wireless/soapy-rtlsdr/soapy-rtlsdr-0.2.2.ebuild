# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="SoapySDR RTL-SDR Support Module"
HOMEPAGE="https://github.com/pothosware/SoapyRTLSDR"
SRC_URI="https://github.com/pothosware/SoapyRTLSDR/archive/${P}.tar.gz"

LICENSE="MIT-with-advertising"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-wireless/rtl-sdr
	net-wireless/soapysdr:=
"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	mv SoapyRTLSDR-* "${S}"
}
