# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="A pure-Python implementation of the HTTP/2 priority tree"
HOMEPAGE="https://python-hyper.org/priority/en/latest/
	https://github.com/python-hyper/priority
	https://pypi.org/project/priority/"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~mips ppc ppc64 s390 sparc x86"
RESTRICT="mirror test"

RDEPEND="
	!<dev-python/priority-1.3.0-r200[${PYTHON_USEDEP}]
"
