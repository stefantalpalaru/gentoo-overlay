# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
MY_COMMIT="41e042935ee9840c0b9dd55d61b6ddd58bc4fde6"

inherit linux-mod-r1

DESCRIPTION="Linux kernel driver for reading sensors of AMD Zen family CPUs"
HOMEPAGE="https://github.com/AliEmreSenel/zenpower3"
SRC_URI="https://github.com/AliEmreSenel/zenpower3/archive/${MY_COMMIT}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/zenpower3-${MY_COMMIT}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

CONFIG_CHECK="HWMON PCI AMD_NB"

PATCHES="${FILESDIR}/zenpower3-0.2.0-use-symlink-to-detect-kernel-version.patch"

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
