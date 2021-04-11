# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Fast NumPy array functions written in Cython"
HOMEPAGE="https://pypi.org/project/Bottleneck/"
SRC_URI="https://github.com/kwgoodman/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="python2"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	>=dev-python/numpy-python2-1.9.1[${PYTHON_USEDEP}]
	dev-python/scipy-python2[${PYTHON_USEDEP}]
	!<dev-python/bottleneck-1.3.1-r4[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose )"

python_test() {
	${EPYTHON} ./tools/test-installed-bottleneck.py
}
