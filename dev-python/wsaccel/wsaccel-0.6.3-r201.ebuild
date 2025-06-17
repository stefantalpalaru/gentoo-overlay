# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
DISTUTILS_EXT=1

inherit distutils-r1

DESCRIPTION="Accelerator for ws4py, autobahn and tornado"
HOMEPAGE="https://pypi.org/project/wsaccel/
		https://github.com/methane/wsaccel"
SRC_URI="https://github.com/methane/wsaccel/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 arm ~arm64 x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="mirror !test? ( test )"

RDEPEND="
	!<dev-python/wsaccel-0.6.3-r200[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	test? (	dev-python/pytest[${PYTHON_USEDEP}] )
"

python_compile() {
	cython_py2 --force wsaccel/*.pyx
	distutils-r1_python_compile
}

python_test() {
	py.test -v || die
}
