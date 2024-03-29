# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Py.test plugin to test server connections locally"
HOMEPAGE="https://pypi.org/project/pytest-localserver/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 sparc x86"
RESTRICT="test"

RDEPEND=">=dev-python/werkzeug-0.10[${PYTHON_USEDEP}]
	!<dev-python/pytest-localserver-0.5.0-r200[${PYTHON_USEDEP}]
"
