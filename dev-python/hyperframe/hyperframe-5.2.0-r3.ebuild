# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="HTTP/2 framing layer for Python"
HOMEPAGE="https://python-hyper.org/en/latest/
	https://pypi.org/project/hyperframe/
	https://github.com/python-hyper/hyperframe"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 s390 sparc x86"

RDEPEND="
	!<dev-python/hyperframe-5.2.0-r3[${PYTHON_USEDEP}]
"
