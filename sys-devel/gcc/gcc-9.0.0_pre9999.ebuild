# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
I_PROMISE_TO_SUPPLY_PATCHES_WITH_BUGS=1
gcc_LIVE_BRANCH="master"

inherit toolchain

RDEPEND=""
DEPEND="${RDEPEND}
	elibc_glibc? ( >=sys-libs/glibc-2.13 )
	>=${CATEGORY}/binutils-2.20"

if [[ ${CATEGORY} != cross-* ]] ; then
	PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.13 )"
fi

src_prepare() {
	# non-bare checkouts are broken with git-2.eclass and recent Git versions not supporting the "-u" switch
	git config core.bare false
	git checkout -f
	toolchain_src_prepare
}
