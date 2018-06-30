# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
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

echo ${D}/${LIBPATH}

src_prepare() {
	toolchain_src_prepare
}
