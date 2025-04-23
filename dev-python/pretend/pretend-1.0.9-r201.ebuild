# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A library for stubbing in Python"
HOMEPAGE="https://github.com/alex/pretend/
		https://pypi.org/project/pretend/"
SRC_URI="https://github.com/alex/pretend/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
RESTRICT="mirror test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
RDEPEND="
	!<dev-python/pretend-1.0.9-r200[${PYTHON_USEDEP}]
"
