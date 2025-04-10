# Copyright 2018-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="A platform independent file lock for Python"
HOMEPAGE="https://github.com/benediktschmitt/py-filelock
		https://pypi.org/project/filelock/"
SRC_URI="https://github.com/benediktschmitt/py-filelock/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="Unlicense"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ppc ppc64 ~riscv ~s390 sparc x86"
RESTRICT="mirror"

RDEPEND="
	!<dev-python/filelock-3.0.12-r3[${PYTHON_USEDEP}]
"
