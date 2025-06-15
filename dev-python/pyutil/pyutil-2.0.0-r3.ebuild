# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="A collection of utilities for Python programmers"
HOMEPAGE="https://tahoe-lafs.org/trac/pyutil
		https://pypi.org/project/pyutil/
		https://github.com/tpltnt/pyutil"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="mirror test"

RDEPEND="
	dev-python/simplejson[${PYTHON_USEDEP}]
	dev-python/twisted[${PYTHON_USEDEP}]
"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

src_install() {
	distutils-r1_src_install
	rm -rf "${ED}"/usr/share/doc/${PN}
}
