# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
# pkg_resources namespace
DISTUTILS_USE_SETUPTOOLS=rdepend
DISTUTILS_EXT=1
PYTHON_COMPAT=( python2_7 )
MY_PN=${PN/-/.}
MY_P=${MY_PN}-${PV}
PYPI_NO_NORMALIZE=1
PYPI_PN="${MY_PN}"

inherit distutils-r1 flag-o-matic pypi

DESCRIPTION="Interfaces for Python"
HOMEPAGE="https://pypi.org/project/zope.interface/
		https://github.com/zopefoundation/zope.interface"
S="${WORKDIR}/${MY_P}"
LICENSE="ZPL"
SLOT="python2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
RESTRICT="mirror"

RDEPEND="
	!<dev-python/zope-interface-5.1.2-r200[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/zope-event[${PYTHON_USEDEP}]
		dev-python/zope-testing[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/5.1.0-drop-coverage.patch
)

distutils_enable_tests setup.py

python_compile() {
	local CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}"
	append-flags -fno-strict-aliasing

	distutils-r1_python_compile
}

python_install_all() {
	distutils-r1_python_install_all

	find "${D}" -name '*.pth' -delete || die
}
