# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="C++ template image processing toolkit"
HOMEPAGE="http://cimg.eu/ https://github.com/dtschump/CImg"
EGIT_REPO_URI="https://github.com/dtschump/CImg.git"

LICENSE="CeCILL-2 CeCILL-C"
SLOT="0"
KEYWORDS=""
IUSE="doc"

src_install() {
	dodoc README.txt
	doheader CImg.h
	use doc && dodoc -r html
}
