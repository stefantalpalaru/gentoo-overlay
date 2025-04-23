# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Run a subprocess in a pseudo terminal"
HOMEPAGE="https://github.com/pexpect/ptyprocess"
LICENSE="ISC"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="mirror test"

DEPEND="
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"
RDEPEND="
	!<dev-python/ptyprocess-0.6.0-r200[${PYTHON_USEDEP}]
"
