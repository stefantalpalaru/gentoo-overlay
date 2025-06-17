# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Backport of pathlib-compatible object wrapper for zip files"
HOMEPAGE="https://github.com/jaraco/zipp"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~mips ppc ppc64 s390 sparc x86"
RESTRICT="mirror test"

RDEPEND="dev-python/more-itertools[${PYTHON_USEDEP}]
	!<dev-python/zipp-1.2.0-r200[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs \
	">=dev-python/jaraco-packaging-3.2" \
	">=dev-python/rst-linker-1.9"

python_prepare_all() {
	sed -i "s:use_scm_version=True:version='${PV}',name='${PN//-/.}':" setup.py || die
	sed -r -i "s:setuptools_scm[[:space:]]*([><=]{1,2}[[:space:]]*[0-9.a-zA-Z]+|)[[:space:]]*::" \
		setup.cfg || die
	distutils-r1_python_prepare_all
}
