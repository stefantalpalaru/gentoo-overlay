# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="An implementation of time.monotonic() for Python 2 & < 3.3"
HOMEPAGE="https://github.com/atdt/monotonic"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~s390 ~sparc x86"
# no tests
RESTRICT="mirror test"

RDEPEND="
	!<dev-python/monotonic-1.5-r200[${PYTHON_USEDEP}]
"
