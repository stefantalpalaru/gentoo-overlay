# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
MYPN=PyAVM
MYP=${MYPN}-${PV}
PYPI_NO_NORMALIZE=1
PYPI_PN="${MYPN}"

inherit distutils-r1 pypi

DESCRIPTION="Python module for Astronomy Visualization Metadata i/o"
HOMEPAGE="http://astrofrog.github.io/pyavm/"
S="${WORKDIR}/${MYP}"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="mirror !test? ( test )"

RDEPEND="dev-python/astropy[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/astropy[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

python_test() {
	py.test || die "tests for ${EPYTHON} failed"
}
