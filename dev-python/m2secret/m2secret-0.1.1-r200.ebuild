# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )
DISTUTILS_USE_SETUPTOOLS=manual

inherit distutils-r1

DESCRIPTION="Encryption and decryption module and CLI utility"
HOMEPAGE="http://www.heikkitoivonen.net/m2secret https://pypi.org/project/m2secret/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-python/setuptools:python2[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	>=dev-python/m2crypto-0.18[${PYTHON_USEDEP}]
"
