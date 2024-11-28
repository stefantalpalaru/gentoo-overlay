# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
#DISTUTILS_USE_SETUPTOOLS=no
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi xdg-utils

MYPV=${PV/_/}

DESCRIPTION="Helpers for Astropy and Affiliated packages"
HOMEPAGE="https://github.com/astropy/astropy-helpers"
S=${WORKDIR}/${PN}-${MYPV}
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
RESTRICT="test"

RDEPEND="${PYTHON_DEPS}"

python_prepare_all() {
	sed -e '/import ah_bootstrap/d' \
		-i setup.py || die "Removing ah_bootstrap failed"
	xdg_environment_reset
	distutils-r1_python_prepare_all
}
