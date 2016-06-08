# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Refocus-It plugin for The Gimp"
SRC_URI="mirror://sourceforge/refocus-it/${P}.tar.gz"
HOMEPAGE="http://refocus-it.sf.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-gfx/gimp:2
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
