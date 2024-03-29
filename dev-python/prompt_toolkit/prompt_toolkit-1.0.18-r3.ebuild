# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="Building powerful interactive command lines in Python"
HOMEPAGE="https://pypi.org/project/prompt_toolkit/
	https://github.com/prompt-toolkit/python-prompt-toolkit"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ppc64 x86"
IUSE=""

RDEPEND="
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	dev-python/wcwidth[${PYTHON_USEDEP}]
	!<dev-python/prompt_toolkit-1.0.18-r3[${PYTHON_USEDEP}]
"
