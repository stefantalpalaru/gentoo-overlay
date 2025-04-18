# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="The official python SDK for Linode API v4"
HOMEPAGE="https://github.com/linode/linode_api4-python"
SRC_URI="https://github.com/linode/linode_api4-python/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-python-${PV}"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

RDEPEND="
	dev-python/future[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	virtual/python-enum34[${PYTHON_USEDEP}]
"

src_prepare() {
	default
	rm -rf test || die
}
