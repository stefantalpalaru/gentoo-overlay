# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python implementation of RFC6570, URI Template"
HOMEPAGE="https://pypi.org/project/uritemplate/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="python2"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"
RESTRICT="test"

RDEPEND="
	dev-python/simplejson:python2[${PYTHON_USEDEP}]
	!<=dev-python/google-api-python-client-1.3[${PYTHON_USEDEP}]
	!<dev-python/uritemplate-3.0.1-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
