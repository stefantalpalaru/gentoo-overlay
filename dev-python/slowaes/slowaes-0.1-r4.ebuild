# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

MY_P=${P}a1
DESCRIPTION="AES implementation in pure Python"
HOMEPAGE="https://code.google.com/p/slowaes/"
SRC_URI="$(pypi_sdist_url "${PN}" "${PV}"a1)"
S=${WORKDIR}/${MY_P}
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="mirror"

DEPEND="dev-python/setuptools"
