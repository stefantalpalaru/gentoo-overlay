# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="external Virtualenv plugin that adds Tauthon support "
HOMEPAGE="https://github.com/stefantalpalaru/virtualenv-tauthon"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

DEPEND="
	dev-python/virtualenv[${PYTHON_USEDEP}]
"
