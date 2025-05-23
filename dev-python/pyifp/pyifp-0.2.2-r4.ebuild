# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="Python bindings for libifp library for accessing iRiver iFP devices"
HOMEPAGE="http://ifp-gnome.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/ifp-gnome/${P}.tar.gz"
LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

RDEPEND=">=media-libs/libifp-1.0.0.2"
DEPEND="${RDEPEND}
	dev-lang/swig"

pkg_setup() {
	python-single-r1_pkg_setup
}

PATCHES=( "${FILESDIR}"/${P}-setup-fix.patch )
