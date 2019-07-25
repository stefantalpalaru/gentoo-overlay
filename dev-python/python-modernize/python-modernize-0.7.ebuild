# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{5,6,7} )

DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1

DESCRIPTION="Modernizes Python code for eventual Python 3 migration"
HOMEPAGE="https://github.com/python-modernize/python-modernize"
SRC_URI="https://github.com/python-modernize/python-modernize/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD-3"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
DEPEND="$RDEPEND"
