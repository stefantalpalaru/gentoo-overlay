# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Gentoo Portage plugin for yolk"
HOMEPAGE="https://pypi.org/project/yolk-portage/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="mirror"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=">=app-portage/portage-utils-0.1.23"
