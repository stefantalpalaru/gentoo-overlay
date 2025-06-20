# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="utility that takes a screenshot using the framebuffer device"
HOMEPAGE="http://jwilk.net/software/fbcat
	https://github.com/jwilk/fbcat"
SRC_URI="https://github.com/jwilk/${PN}/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc fbgrab"
RESTRICT="mirror"

DEPEND="
	doc? ( dev-libs/libxslt ) \
	fbgrab? ( !!media-gfx/fbgrab ) \
"

src_compile() {
	emake
	if use doc; then
		emake -C doc
	fi
}

src_install() {
	dobin fbcat
	if use fbgrab; then
		dobin fbgrab
	fi
	if use doc; then
		doman doc/fbcat.1
		if use fbgrab; then
			doman doc/fbgrab.1
		fi
	fi
}
