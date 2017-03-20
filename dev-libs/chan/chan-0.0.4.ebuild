# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils

DESCRIPTION="pure C implementation of Go channels"
HOMEPAGE="https://github.com/tylertreat/chan"
SRC_URI="https://github.com/tylertreat/chan/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc static-libs test"

DEPEND=""
RDEPEND=""

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	DOCS=""
	use doc && DOCS="README.md"
	default
	prune_libtool_files
}
