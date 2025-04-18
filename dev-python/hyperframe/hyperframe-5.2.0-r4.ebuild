# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="HTTP/2 framing layer for Python"
HOMEPAGE="https://python-hyper.org/en/latest/
	https://pypi.org/project/hyperframe/
	https://github.com/python-hyper/hyperframe"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~mips ppc ppc64 s390 sparc x86"
RESTRICT="mirror test"

RDEPEND="
	!<dev-python/hyperframe-5.2.0-r3[${PYTHON_USEDEP}]
"
