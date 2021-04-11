# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python library to sort collections and containers"
HOMEPAGE="http://www.grantjenks.com/docs/sortedcontainers/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

RDEPEND="dev-python/sortedcontainers:python2[${PYTHON_USEDEP}]
	!<dev-python/sortedcollections-0.5.3-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
