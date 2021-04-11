# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Modern password hashing for software and servers"
HOMEPAGE="https://github.com/pyca/bcrypt/
		https://pypi.org/project/bcrypt/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="python2"
LICENSE="Apache-2.0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris"
RESTRICT="test"

RDEPEND="
	>=dev-python/cffi-1.1:=[${PYTHON_USEDEP}]
	>=dev-python/six-1.4.1:python2[${PYTHON_USEDEP}]
	!<dev-python/bcrypt-3.1.7-r6[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
