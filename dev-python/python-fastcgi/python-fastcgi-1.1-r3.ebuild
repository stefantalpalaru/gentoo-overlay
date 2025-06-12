# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1
DISTUTILS_EXT=1

inherit distutils-r1 flag-o-matic pypi

DESCRIPTION="Interface to OpenMarket's FastCGI C Library/SDK"
HOMEPAGE="https://pypi.org/project/python-fastcgi/"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"
RESTRICT="mirror"

RDEPEND="
	>=dev-libs/fcgi-2.4.0-r2
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}/${P}-setup.patch" )

python_prepare_all() {
	distutils-r1_python_prepare_all
	append-cflags -fno-strict-aliasing -fpermissive
}

python_install_all() {
	use examples && local EXAMPLES=( example/. )
	distutils-r1_python_install_all
}
