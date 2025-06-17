# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
DISTUTILS_EXT=1

inherit distutils-r1 pypi

DESCRIPTION="Fast erasure codec for the command-line, C, Python, or Haskell"
HOMEPAGE="https://pypi.org/project/zfec/
		https://github.com/tahoe-lafs/zfec"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="mirror test"

COMMON_DEPEND=""
RDEPEND="${COMMON_DEPEND}
	dev-python/pyutil[${PYTHON_USEDEP}]
	dev-python/zbase32[${PYTHON_USEDEP}]"
DEPEND="${COMMON_DEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

src_install() {
	distutils-r1_src_install

	rm -rf "${ED}"/usr/share/doc/${PN}
}
