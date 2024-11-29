# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Namespace control and lazy-import mechanism"
HOMEPAGE="https://pypi.org/project/apipkg/
		https://github.com/pytest-dev/apipkg"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86"
RESTRICT="test"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools-scm[${PYTHON_USEDEP}]"
RDEPEND="
	!<dev-python/apipkg-1.5-r3[${PYTHON_USEDEP}]
"
