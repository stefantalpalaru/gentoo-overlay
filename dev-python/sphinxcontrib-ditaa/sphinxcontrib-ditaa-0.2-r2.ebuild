# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Ditaa Sphinx extension"
HOMEPAGE="https://pypi.org/project/sphinxcontrib-ditaa/"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
RESTRICT="mirror"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/sphinx[${PYTHON_USEDEP}]
	media-gfx/ditaa"

python_install_all() {
	distutils-r1_python_install_all
	find "${ED}" -name '*.pth' -delete || die
}
