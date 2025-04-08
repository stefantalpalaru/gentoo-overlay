# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Standalone tools related to diskimage-builder."
HOMEPAGE="https://git.openstack.org/cgit/openstack/dib-utils"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror test"

CDEPEND=">=dev-python/pbr-1.6:python2[${PYTHON_USEDEP}]"
DEPEND="${CDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${CDEPEND}
	!<dev-python/dib-utils-0.0.10-r200[${PYTHON_USEDEP}]
"
