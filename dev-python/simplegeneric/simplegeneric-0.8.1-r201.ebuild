# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Simple generic functions for Python"
HOMEPAGE="https://pypi.org/project/simplegeneric/"
SRC_URI="$(pypi_sdist_url "${PN}" "${PV}" .zip)"
LICENSE="ZPL"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
RESTRICT="mirror"

DEPEND="
	app-arch/unzip
	dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	!<dev-python/simplegeneric-0.8.1-r200[${PYTHON_USEDEP}]
"

python_test() {
	esetup.py test
}
