# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="C++ template image processing toolkit"
HOMEPAGE="http://cimg.eu/
		https://github.com/GreycLab/CImg"
SRC_URI="https://github.com/GreycLab/CImg/archive/v.${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/CImg-v.${PV}"
LICENSE="CeCILL-2 CeCILL-C"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc"
RESTRICT="mirror"

src_install() {
	doheader CImg.h
	dodoc README.txt
	if use doc; then
		dodoc -r html
	fi
}
