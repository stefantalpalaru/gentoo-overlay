# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
DISTUTILS_EXT=1

inherit distutils-r1

DESCRIPTION="Python interface to libpcap"
HOMEPAGE="https://sourceforge.net/projects/pylibpcap/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~hppa x86"
IUSE="examples"
RESTRICT="mirror"

RDEPEND="net-libs/libpcap"
DEPEND="${RDEPEND}"

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
