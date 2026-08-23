# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
MY_COMMIT="a05f47c704f550f0e94808b1d23d8eb1fbc77209"

inherit linux-mod-r1

DESCRIPTION="Linux kernel driver for reading sensors of AMD Zen family CPUs"
HOMEPAGE="https://github.com/AliEmreSenel/zenpower3"
SRC_URI="https://github.com/AliEmreSenel/zenpower3/archive/${MY_COMMIT}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/zenpower3-${MY_COMMIT}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

CONFIG_CHECK="HWMON PCI AMD_NB"

PATCHES=(
	"${FILESDIR}"/zenpower3-0.2.0-use-symlink-to-detect-kernel-version.patch
)

src_compile() {
	export TARGET=${KV_FULL}
	local modlist=(
		zenpower=misc:::all
	)
	linux-mod-r1_src_compile
}

src_install() {
	linux-mod-r1_src_install
	dobin zp_read_debug.sh
	dodoc README.md
}
