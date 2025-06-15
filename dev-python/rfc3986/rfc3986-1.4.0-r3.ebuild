# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Validating URI References per RFC 3986"
HOMEPAGE="https://tools.ietf.org/html/rfc3986
	https://github.com/python-hyper/rfc3986
	https://rfc3986.rtfd.org"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 ~s390 sparc x86"
IUSE="idna"
RESTRICT="mirror test"

RDEPEND="
	idna? ( dev-python/idna[${PYTHON_USEDEP}] )
	!<dev-python/rfc3986-1.4.0-r2[${PYTHON_USEDEP}]
"
