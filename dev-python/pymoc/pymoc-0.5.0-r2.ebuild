# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Python Multi-Order Coverage maps for Virtual Observatory"
HOMEPAGE="https://pymoc.readthedocs.org/"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror"

RDEPEND="
	dev-python/astropy[${PYTHON_USEDEP}]
	dev-python/healpy[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

python_test() {
	PYTHONPATH=lib "${PYTHON}" -m unittest discover -s test || die
}
