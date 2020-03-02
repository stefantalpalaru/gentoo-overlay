# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/casebeer/python-hkdf.git"
	KEYWORDS=""
else
	KEYWORDS="~amd64"
	EGIT_COMMIT="cc3c9dbf0a271b27a7ac5cd04cc1485bbc3b4307"
	SRC_URI="https://github.com/casebeer/python-hkdf/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/python-${PN}-${EGIT_COMMIT}"
fi

DESCRIPTION="Python implementation of HKDF"
HOMEPAGE="https://github.com/casebeer/python-hkdf"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
