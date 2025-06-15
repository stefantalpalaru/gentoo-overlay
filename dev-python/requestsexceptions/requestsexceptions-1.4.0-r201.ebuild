# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Finds the correct path to exceptions in the requests library."
HOMEPAGE="https://github.com/openstack-infra/requestsexceptions"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 ~arm64 x86"
RESTRICT="mirror test"

CDEPEND=">=dev-python/pbr-2.0.0:python2[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}"
RDEPEND="${CDEPEND}
	!<dev-python/requestsexceptions-1.4.0-r3[${PYTHON_USEDEP}]
"
