# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Finds the correct path to exceptions in the requests library."
HOMEPAGE="https://github.com/openstack-infra/requestsexceptions"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""
RESTRICT="test"

CDEPEND=">=dev-python/pbr-2.0.0:python2[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}"
RDEPEND="${CDEPEND}
	!<dev-python/requestsexceptions-1.4.0-r3[${PYTHON_USEDEP}]
"
