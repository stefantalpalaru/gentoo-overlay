# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="LZ4 Bindings for Python"
HOMEPAGE="https://pypi.org/project/lz4/ https://github.com/python-lz4/python-lz4"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux"
RESTRICT="test"

RDEPEND="app-arch/lz4
	!<dev-python/lz4-2.2.1-r200[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	dev-python/pkgconfig[${PYTHON_USEDEP}]
"
