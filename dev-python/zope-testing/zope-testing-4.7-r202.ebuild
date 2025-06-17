# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
MY_PN=${PN/-/.}
MY_P=${MY_PN}-${PV}
PYPI_NO_NORMALIZE=1
PYPI_PN="${MY_PN}"

inherit distutils-r1 pypi

DESCRIPTION="Zope testing helpers"
HOMEPAGE="https://pypi.org/project/zope.testing/
	https://github.com/zopefoundation/zope.testing"
S="${WORKDIR}/${MY_P}"
LICENSE="ZPL"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
RESTRICT="mirror"

RDEPEND="
	!<dev-python/zope-testing-4.7-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

distutils_enable_tests setup.py

python_install_all() {
	distutils-r1_python_install_all

	find "${D}" -name '*.pth' -delete || die
}
