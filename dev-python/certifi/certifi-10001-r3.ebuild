# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_P=certifi-shim-${PV}
DESCRIPTION="Thin replacement for certifi using system certificate store"
HOMEPAGE="
	https://github.com/mgorny/certifi-shim
	https://pypi.org/project/certifi"
SRC_URI="
	https://github.com/mgorny/certifi-shim/archive/v${PV}.tar.gz -> ${MY_P}.gh.tar.gz"
S=${WORKDIR}/${MY_P}
LICENSE="CC0-1.0"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
RESTRICT="mirror test"

RDEPEND="
	app-misc/ca-certificates
	!<dev-python/certifi-10001-r2[${PYTHON_USEDEP}]
"

src_prepare() {
	sed -i -e "s^/etc^${EPREFIX}/etc^" certifi/core.py || die
	distutils-r1_src_prepare
}
