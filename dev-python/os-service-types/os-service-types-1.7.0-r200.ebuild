# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A library to handle official service types for OpenStack and it's aliases."
HOMEPAGE="https://github.com/openstack/os-service-types"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""
RESTRICT="test"

CDEPEND=">=dev-python/pbr-2.0.0:python2[${PYTHON_USEDEP}]
	!~dev-python/pbr-2.1.0"
DEPEND="${CDEPEND}"
RDEPEND="${CDEPEND}
	!<dev-python/os-service-types-1.7.0-r200[${PYTHON_USEDEP}]
"
