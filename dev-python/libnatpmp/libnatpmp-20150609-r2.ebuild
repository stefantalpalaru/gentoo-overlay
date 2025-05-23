# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python module for libnatpmp, an alternative protocol to UPnP IGD"
HOMEPAGE="http://miniupnp.free.fr/libnatpmp.html"
SRC_URI="http://miniupnp.free.fr/files/download.php?file=${P}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

DEPEND="~net-libs/${P}"
RDEPEND="${DEPEND}"

python_prepare_all() {
	default
	patch -p1 -i "${FILESDIR}"/link-against-system-lib.patch

	#These are installed by net-libs/libnatpmp
	rm -f Changelog.txt README || die
	distutils-r1_python_prepare_all
}
