# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Python implementation of RFC6570, URI Template"
HOMEPAGE="https://pypi.org/project/uritemplate/"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror test"

RDEPEND="
	dev-python/simplejson:python2[${PYTHON_USEDEP}]
	!<=dev-python/google-api-python-client-1.3[${PYTHON_USEDEP}]
	!<dev-python/uritemplate-3.0.1-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
