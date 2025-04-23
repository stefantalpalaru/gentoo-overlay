# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1
DISTUTILS_EXT=1

inherit distutils-r1 pypi

DESCRIPTION="Universal Binary JSON encoder/decoder"
HOMEPAGE="https://github.com/Iotic-Labs/py-ubjson
		https://pypi.org/project/py-ubjson/"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror"

RDEPEND="
	!<dev-python/py-ubjson-0.16.1-r200[${PYTHON_USEDEP}]
"

src_prepare() {
	# to make unittest happy
	touch test/__init__.py || die
	distutils-r1_src_prepare
}
