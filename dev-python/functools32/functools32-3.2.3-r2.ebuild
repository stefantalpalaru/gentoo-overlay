# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Backport of the functools module from Python 3"
HOMEPAGE="https://pypi.org/project/functools32/
		https://github.com/MiCHiLU/python-functools32"
SRC_URI="$(pypi_sdist_url "${PN}" "${PV}-2")"
S="${WORKDIR}"/${P}-2
LICENSE="PSF-2.4"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror"

python_test() {
	"${PYTHON}" test_functools32.py || die
}
