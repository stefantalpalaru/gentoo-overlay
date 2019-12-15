# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

MY_COMMIT="5a99ff7fed66b8ea8f09c9805c138524a7035ece"

DESCRIPTION="A C library for producing symbolic backtraces"
HOMEPAGE="https://github.com/ianlancetaylor/libbacktrace"
SRC_URI="https://github.com/ianlancetaylor/libbacktrace/archive/${MY_COMMIT}.zip -> ${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 -sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="+static-libs test"

RDEPEND="
	sys-libs/zlib
"
DEPEND="${RDEPEND}"
BDEPEND=""

S="${WORKDIR}/${PN}-${MY_COMMIT}"

PATCHES=(
	"${FILESDIR}/am_enable_multilib.patch"
)

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" \
	econf \
		$(use_enable static-libs static)
}
