# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Parameterized testing with any Python test framework"
HOMEPAGE="https://github.com/wolever/parameterized"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

RDEPEND="
	!<dev-python/parameterized-0.7.4-r200[${PYTHON_USEDEP}]
"

distutils_enable_tests nose
