# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="A utility belt for advanced users of python-requests"
HOMEPAGE="https://toolbelt.readthedocs.org/
		https://github.com/requests/toolbelt"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ppc ppc64 sparc x86"
RESTRICT="mirror test"

RDEPEND="<dev-python/requests-3.0.0:python2[${PYTHON_USEDEP}]
	!<dev-python/requests-toolbelt-0.9.1-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS.rst HISTORY.rst README.rst )
