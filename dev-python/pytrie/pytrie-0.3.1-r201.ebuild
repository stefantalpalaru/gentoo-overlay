# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1
MY_PN="PyTrie"
MY_P="${MY_PN}-${PV}"
PYPI_PN="${MY_PN}"

inherit distutils-r1 pypi

DESCRIPTION="A pure Python implementation of the trie data structure"
HOMEPAGE="https://github.com/gsakkis/pytrie/
		https://pypi.org/project/PyTrie/"
S="${WORKDIR}/${MY_P}"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror"

RDEPEND="dev-python/sortedcontainers[${PYTHON_USEDEP}]
	!<dev-python/pytrie-0.3.1-r200[${PYTHON_USEDEP}]
"

distutils_enable_tests setup.py
