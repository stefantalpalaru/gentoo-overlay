# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools-utils git-r3

DESCRIPTION="pure C implementation of Go channels"
HOMEPAGE="https://github.com/tylertreat/chan"
EGIT_REPO_URI="https://github.com/tylertreat/chan"
EGIT_CLONE_TYPE="shallow"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="doc static-libs test"

DEPEND=""
RDEPEND=""

src_prepare() {
	eautoreconf
}

src_install() {
	DOCS=""
	use doc && DOCS="README.md"
	autotools-utils_src_install
}
