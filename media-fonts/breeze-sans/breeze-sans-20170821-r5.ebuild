# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

DESCRIPTION="humanist sans-serif typeface designed by Dalton Maag for Samsung"
#HOMEPAGE="https://developer.tizen.org/design/platform/styles/typography
	#https://review.tizen.org/git/?p=platform/core/graphics/default-fonts-sdk.git;a=tree;hb=HEAD"
HOMEPAGE="https://github.com/stefantalpalaru/breeze-sans"
#commit="efd8b8a5d8e88e3122037fa126831c5a938736a7"
#SRC_URI="https://review.tizen.org/git/?p=platform/core/graphics/default-fonts-sdk.git;a=snapshot;h=${commit};sf=tgz -> ${P}.tar.gz"
SRC_URI="https://github.com/stefantalpalaru/breeze-sans/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"
#S="${WORKDIR}/default-fonts-sdk-${commit:0:7}"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
RESTRICT="mirror"

FONT_S=(
	"${S}/common/fonts"
	"${S}/common/fallback_fonts"
)
FONT_SUFFIX="ttf"
