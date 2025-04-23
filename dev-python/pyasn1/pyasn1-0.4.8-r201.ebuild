# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="ASN.1 library for Python"
HOMEPAGE="http://snmplabs.com/pyasn1/
		https://github.com/etingof/pyasn1"
LICENSE="BSD-2"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="doc"
RESTRICT="mirror"

RDEPEND="
	!<dev-python/pyasn1-0.4.8-r200[${PYTHON_USEDEP}]
"

distutils_enable_tests setup.py
distutils_enable_sphinx "docs/source"
