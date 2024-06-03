# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 linux-mod-r1

DESCRIPTION="Experimental Logitech force feedback module"
HOMEPAGE="https://github.com/berarma/new-lg4ff"
EGIT_REPO_URI="https://github.com/berarma/${PN}"
LICENSE="GPL-2"
SLOT="0"

# https://github.com/berarma/new-lg4ff/issues/57#issuecomment-1019325204
CONFIG_CHECK="LOGIWHEELS_FF"

src_prepare() {
	default

	sed -i \
		-e "s%KDIR := .*%KDIR := ${KERNEL_DIR}%g" \
		Makefile
}

src_compile() {
	local modlist=( hid-logitech-new=kernel/drivers/hid )

	linux-mod-r1_src_compile
}
