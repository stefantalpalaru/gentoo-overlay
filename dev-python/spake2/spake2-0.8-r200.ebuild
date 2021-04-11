# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

KEYWORDS="~amd64 ~x86"
EGIT_COMMIT="v${PV}"
SRC_URI="https://github.com/warner/python-spake2/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
DESCRIPTION="Python implementation of SPAKE2"
HOMEPAGE="https://github.com/warner/python-spake2"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="test"

RDEPEND="
	dev-python/hkdf:python2[${PYTHON_USEDEP}]
	!<dev-python/spake2-0.8-r200[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

python_check_deps() {
	has_version "dev-python/hkdf:python2[${PYTHON_USEDEP}]"
}

S="${WORKDIR}/python-${P}"
