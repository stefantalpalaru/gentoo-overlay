# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Refocus-It plugin for The Gimp"
HOMEPAGE="http://refocus-it.sf.net/"
SRC_URI="https://downloads.sourceforge.net/refocus-it/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-gfx/gimp:0/2
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
