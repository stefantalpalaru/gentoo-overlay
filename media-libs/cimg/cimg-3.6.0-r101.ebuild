# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
MY_COMMIT="62cbf196420896bf42230090282b19b83cfb9253"

DESCRIPTION="C++ template image processing toolkit"
HOMEPAGE="http://cimg.eu/
		https://github.com/GreycLab/CImg"
# Upstream re-tags newer commits with old tags, leading to broken checksums and
# broken gmic compilation, due to cimg API changes: https://github.com/GreycLab/CImg/issues/466
# This means we need to use commit hashes instead of tags, for the source archive.
SRC_URI="https://github.com/GreycLab/CImg/archive/${MY_COMMIT}.tar.gz -> ${P}-${MY_COMMIT}.gh.tar.gz"
S="${WORKDIR}/CImg-${MY_COMMIT}"
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
