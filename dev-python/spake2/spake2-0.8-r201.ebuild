# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
EGIT_COMMIT="v${PV}"

inherit distutils-r1

DESCRIPTION="Python implementation of SPAKE2"
HOMEPAGE="https://github.com/warner/python-spake2"
SRC_URI="https://github.com/warner/python-spake2/archive/${EGIT_COMMIT}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/python-${P}"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="mirror test"

RDEPEND="
	dev-python/hkdf:python2[${PYTHON_USEDEP}]
	!<dev-python/spake2-0.8-r200[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
