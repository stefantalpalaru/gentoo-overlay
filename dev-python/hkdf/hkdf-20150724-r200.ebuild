# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python implementation of HKDF"
HOMEPAGE="https://github.com/casebeer/python-hkdf"
KEYWORDS="~amd64"
EGIT_COMMIT="cc3c9dbf0a271b27a7ac5cd04cc1485bbc3b4307"
SRC_URI="https://github.com/casebeer/python-hkdf/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/python-${PN}-${EGIT_COMMIT}"
LICENSE="BSD-2"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	!<dev-python/hkdf-20150724-r200[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
