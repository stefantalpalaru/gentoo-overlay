# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Python attributes without the boilerplate"
HOMEPAGE="https://characteristic.readthedocs.org/
		https://github.com/hynek/characteristic"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 s390 sparc x86"
RESTRICT="mirror test"

RDEPEND="
	!<dev-python/characteristic-14.3.0-r6[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs

python_prepare_all() {
	sed -e 's|\[pytest\]|\[tool:pytest\]|' -i setup.cfg || die
	distutils-r1_python_prepare_all
}
