# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Plugin for testing Cython extension modules"
HOMEPAGE="https://github.com/lgpage/pytest-cython"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror test"

RDEPEND="dev-python/pytest:python2[${PYTHON_USEDEP}]
	!<dev-python/pytest-cython-0.1.0-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
