# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="This package contains tools for authenticating to an OpenStack-based cloud."
HOMEPAGE="https://github.com/openstack/keystoneauth"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 ~arm64 x86"
RESTRICT="test"

CDEPEND=">=dev-python/pbr-2.0.0:python2[${PYTHON_USEDEP}]
	!~dev-python/pbr-2.1.0"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}"
RDEPEND="${CDEPEND}
	>=dev-python/iso8601-0.1.11[${PYTHON_USEDEP}]
	>=dev-python/requests-2.14.2[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.20.0[${PYTHON_USEDEP}]
	>=dev-python/os-service-types-1.2.0[${PYTHON_USEDEP}]
	!<dev-python/keystoneauth1-3.18.0-r3[${PYTHON_USEDEP}]
"
