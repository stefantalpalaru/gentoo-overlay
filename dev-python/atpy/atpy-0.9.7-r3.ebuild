# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"
PYPI_PN="ATpy"
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

MYPN=ATpy
MYP="${MYPN}-${PV}"

DESCRIPTION="Astronomical tables support for Python"
HOMEPAGE="http://atpy.readthedocs.org/"
S="${WORKDIR}/${MYP}"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="hdf5 mysql postgres sqlite"

DEPEND="dev-python/numpy:python2[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	dev-python/astropy[${PYTHON_USEDEP}]
	hdf5? ( dev-python/h5py[${PYTHON_USEDEP}] )
	mysql? ( dev-python/mysql-python[${PYTHON_USEDEP}] )
	postgres? ( dev-python/pygresql )"

python_test() {
	PYTHONPATH="${BUILD_DIR}/lib" "${EPYTHON}" runtests.py || die
}
