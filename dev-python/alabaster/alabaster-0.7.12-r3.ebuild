# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 pypi

DESCRIPTION="A configurable sidebar-enabled Sphinx theme"
HOMEPAGE="https://github.com/bitprophet/alabaster"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 s390 sparc x86 ~x64-solaris"
RESTRICT="mirror"

RDEPEND="
	!<dev-python/alabaster-0.7.12-r2[${PYTHON_USEDEP}]
"
