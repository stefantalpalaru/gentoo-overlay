# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="C++ template image processing toolkit"
HOMEPAGE="http://cimg.eu/ https://github.com/dtschump/CImg"
if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dtschump/CImg.git"
else
	SRC_URI="https://github.com/dtschump/CImg/archive/v.${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/CImg-v.${PV}"
fi
LICENSE="CeCILL-2 CeCILL-C"
SLOT="0"
IUSE="doc"

src_install() {
	doheader CImg.h
	dodoc README.txt
	use doc && dodoc -r html
}
