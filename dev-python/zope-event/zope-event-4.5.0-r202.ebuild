# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
MY_PN=${PN/-/.}
MY_P=${MY_PN}-${PV}
PYPI_NO_NORMALIZE=1
PYPI_PN="${MY_PN}"

inherit distutils-r1 pypi

DESCRIPTION="Event publishing / dispatch, used by Zope Component Architecture"
HOMEPAGE="https://github.com/zopefoundation/zope.event
	https://docs.zope.org/zope.event/"
S="${WORKDIR}/${MY_P}"
LICENSE="ZPL"
SLOT="python2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
RESTRICT="mirror"

RDEPEND="
	!<dev-python/zope-event-4.5.0-r200[${PYTHON_USEDEP}]
"

distutils_enable_tests nose

python_install_all() {
	distutils-r1_python_install_all

	find "${D}" -name '*.pth' -delete || die
}
