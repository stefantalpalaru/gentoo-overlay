# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit autotools-utils git-2

DESCRIPTION="digital signal processing library for software-defined radios"
HOMEPAGE="http://liquidsdr.org/"
EGIT_REPO_URI="https://github.com/jgaeddert/liquid-dsp.git"
EGIT_CLONE_TYPE="shallow"

LICENSE="MIT-with-advertising"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="sci-libs/fftw:3.0"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-libdir.patch" )
