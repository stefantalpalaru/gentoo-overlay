# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python2_7)
inherit distutils-r1

DESCRIPTION="An efficient C++ implementation of the Cassowary constraint solving algorithm"
HOMEPAGE="https://github.com/nucleic/kiwi"
SRC_URI="https://github.com/nucleic/kiwi/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Clear-BSD"
SLOT="python2"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ppc64 x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	!<dev-python/kiwisolver-1.1.0-r200[${PYTHON_USEDEP}]
"

S="${WORKDIR}"/kiwi-${PV}
