# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Atomic file writes"
HOMEPAGE="https://github.com/untitaker/python-atomicwrites"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 sparc x86 ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""
RESTRICT="test"

DEPEND=""
RDEPEND="
	!<dev-python/atomicwrites-1.4.0-r3[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs \
	dev-python/sphinx_rtd_theme
