# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Theme and extension support for Sphinx documentation"
HOMEPAGE="https://docs.openstack.org/openstackdocstheme/latest/"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~alpha amd64 ~arm arm64 ~ppc64 x86"
RESTRICT="mirror test"

DEPEND=">=dev-python/pbr-2.0.0:python2[${PYTHON_USEDEP}]
	!~dev-python/pbr-2.1.0[${PYTHON_USEDEP}]
	!<dev-python/openstackdocstheme-1.18.1-r200[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}
	>=dev-python/dulwich-0.15.0[${PYTHON_USEDEP}]"
