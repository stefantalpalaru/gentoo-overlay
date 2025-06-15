# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
DISTUTILS_EXT=1

inherit flag-o-matic distutils-r1 pypi

DESCRIPTION="Provides Python interfaces for Xen's XenStore"
HOMEPAGE="https://launchpad.net/pyxenstore"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86"
RESTRICT="mirror"

DEPEND="app-emulation/xen-tools"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	append-cflags -fpermissive
}
