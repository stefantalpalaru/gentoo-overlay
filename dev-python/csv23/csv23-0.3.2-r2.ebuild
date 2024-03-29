# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="Python 2/3 unicode CSV compatibility layer"
HOMEPAGE="
	https://pypi.org/project/csv23/
	https://github.com/xflr6/csv23/"
SRC_URI="https://github.com/xflr6/csv23/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv sparc x86 ~x64-macos"

RDEPEND="
	!<dev-python/csv23-0.3.2-r2[${PYTHON_USEDEP}]
"

src_prepare() {
	sed -i -e '/--cov/d' setup.cfg || die
	distutils-r1_src_prepare
}
