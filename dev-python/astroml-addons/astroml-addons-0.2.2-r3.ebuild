# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_PN="astroML_addons"
PYPI_NO_NORMALIZE=1
MYPN=astroML_addons
MYP=${MYPN}-${PV}

inherit distutils-r1 pypi

DESCRIPTION="Performance add-ons for the astroML package"
HOMEPAGE="https://github.com/astroML/astroML_addons"
S="${WORKDIR}/${MYP}"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="dev-python/astroml[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/numpy:python2[${PYTHON_USEDEP}]"

DOCS=( README.rst )
