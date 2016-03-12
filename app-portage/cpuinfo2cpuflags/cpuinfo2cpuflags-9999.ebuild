# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils git-r3

DESCRIPTION="Tool to guess CPU_FLAGS_X86 flags for the host"
HOMEPAGE="https://bitbucket.org/mgorny/cpuinfo2cpuflags"
#SRC_URI="https://bitbucket.org/mgorny/cpuinfo2cpuflags/downloads/${P}.tar.bz2"
EGIT_REPO_URI="https://bitbucket.org/mgorny/${PN}.git"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE=""

src_prepare() {
	eautoreconf
}
