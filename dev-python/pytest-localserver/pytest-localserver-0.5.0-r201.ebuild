# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Py.test plugin to test server connections locally"
HOMEPAGE="https://pypi.org/project/pytest-localserver/"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ppc ppc64 sparc x86"
RESTRICT="mirror test"

RDEPEND=">=dev-python/werkzeug-0.10[${PYTHON_USEDEP}]
	!<dev-python/pytest-localserver-0.5.0-r200[${PYTHON_USEDEP}]
"
