# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"
MY_P="yum-metadata-parser-${PV}"
DISTUTILS_EXT=1

inherit distutils-r1

DESCRIPTION="sqlite cacher for python applications"
HOMEPAGE="http://yum.baseurl.org/"
SRC_URI="http://yum.baseurl.org/download/yum-metadata-parser/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
RESTRICT="mirror"

# glib and libxml2 are used via an extension module written in C.
# No need to add PYTHON_USEDEP here.
RDEPEND="dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/libxml2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
