# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
MY_PN="${PN#python-}"
PYPI_PN="${MY_PN}"

inherit distutils-r1 pypi

DESCRIPTION="A python interface to the PAM library on linux using ctypes"
HOMEPAGE="https://atlee.ca/software/pam"
S="${WORKDIR}/${MY_PN}-${PV}"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
