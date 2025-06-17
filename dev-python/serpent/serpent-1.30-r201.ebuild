# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="A simple serialization library based on ast.literal_eval"
HOMEPAGE="https://pypi.org/project/serpent/ https://github.com/irmen/Serpent"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~x86"
RESTRICT="mirror"

RDEPEND="
	!<dev-python/serpent-1.30-r200[${PYTHON_USEDEP}]
"

distutils_enable_tests setup.py
