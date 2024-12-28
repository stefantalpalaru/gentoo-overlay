# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1

DESCRIPTION="kernel driver for AMD Zen sensors (zenpower3 fork)"
HOMEPAGE="https://github.com/Sid127/zenstats"
SRC_URI="https://github.com/Sid127/zenstats/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

CONFIG_CHECK="HWMON PCI AMD_NB"

PATCHES="${FILESDIR}/zenpower3-0.2.0-use-symlink-to-detect-kernel-version.patch"

src_compile() {
	export TARGET=${KV_FULL}
	local modlist=(
		zenstats=misc:::all
	)
	linux-mod-r1_src_compile
}

src_install() {
	linux-mod-r1_src_install
	dobin zs_read_debug.sh
	dodoc README.md
}
