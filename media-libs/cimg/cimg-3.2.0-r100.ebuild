# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="C++ template image processing toolkit"
HOMEPAGE="http://cimg.eu/ https://github.com/dtschump/CImg"

SRC_URI="https://github.com/dtschump/CImg/archive/v.${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
LICENSE="CeCILL-2 CeCILL-C"
SLOT="0"
IUSE="doc"

S="${WORKDIR}/CImg-v.${PV}"

src_install() {
	doheader CImg.h
	dodoc README.txt
	use doc && dodoc -r html
}
