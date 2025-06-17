# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="A Python data validation library."
HOMEPAGE="https://github.com/alecthomas/voluptuous"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror"

RDEPEND="
	!<dev-python/voluptuous-0.12.0-r200[${PYTHON_USEDEP}]
"

PATCHES=( "${FILESDIR}"/${PN}-0.11.5-fix-doctest.patch )

distutils_enable_tests nose
