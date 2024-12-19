# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
MY_COMMIT="07572e66d432877955139d1e9e81fd9e9abc5d0f"

inherit fcaps toolchain-funcs

DESCRIPTION="Zen monitor is monitoring software for AMD Zen-based CPUs"
HOMEPAGE="https://github.com/detiam/zenmonitor3"
SRC_URI="https://github.com/detiam/zenmonitor3/archive/${MY_COMMIT}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cli +filecaps policykit"

DEPEND="
	cli? ( sys-libs/ncurses )
	filecaps? ( sys-libs/libcap )
	x11-libs/gtk+:3
"
RDEPEND="
	${DEPEND}
	policykit? ( sys-auth/polkit )
	sys-kernel/zenpower3
"

PATCHES=(
	"${FILESDIR}/zenmonitor3-makefile-r1.patch"
)

src_compile() {
	tc-export CC
	emake build
	use cli && emake build-cli
}

src_install() {
	dodoc README.md

	DESTDIR="${D}" emake install
	use cli && DESTDIR="${D}" emake install-cli
	if use policykit; then
		mkdir -p "${ED}/usr/share/polkit-1/actions" || die
		DESTDIR="${D}" emake install-polkit
	fi
}

pkg_postinst() {
	fcaps cap_sys_rawio,cap_dac_read_search usr/bin/zenmonitor
	use cli && fcaps cap_sys_rawio,cap_dac_read_search usr/bin/zenmonitor-cli
}
