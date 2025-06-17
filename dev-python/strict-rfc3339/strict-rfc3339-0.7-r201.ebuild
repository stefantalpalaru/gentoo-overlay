# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python2_7 )
MY_PN="${PN}-version"
MY_P="${MY_PN}-${PV}"

inherit distutils-r1

DESCRIPTION="Strict, simple, lightweight RFC3339 functions"
HOMEPAGE="https://pypi.org/project/strict-rfc3339/
		https://github.com/danielrichman/strict-rfc3339"
SRC_URI="https://github.com/danielrichman/${PN}/archive/version-${PV}.tar.gz -> ${MY_P}.gh.tar.gz"
S="${WORKDIR}/${MY_P}"
LICENSE="GPL-3+"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror test"

RDEPEND="
	!<dev-python/strict-rfc3339-0.7-r200[${PYTHON_USEDEP}]
"
