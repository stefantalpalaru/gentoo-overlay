# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Accelerator for ws4py, autobahn and tornado"
HOMEPAGE="https://pypi.org/project/wsaccel/
		https://github.com/methane/wsaccel"
SRC_URI="https://github.com/methane/wsaccel/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="python2"
LICENSE="Apache-2.0"
KEYWORDS="amd64 arm ~arm64 x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	!<dev-python/wsaccel-0.6.3-r200[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	test? (	dev-python/pytest[${PYTHON_USEDEP}] )
"

python_test() {
	py.test -v || die
}
