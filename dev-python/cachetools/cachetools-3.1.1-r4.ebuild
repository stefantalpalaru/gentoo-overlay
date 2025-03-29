# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Extensible memoizing collections and decorators"
HOMEPAGE="https://pypi.org/project/cachetools/"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="amd64 ~arm ~arm64 x86"
RESTRICT="mirror test"

RDEPEND="
	!<dev-python/cachetools-3.1.1-r3[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
