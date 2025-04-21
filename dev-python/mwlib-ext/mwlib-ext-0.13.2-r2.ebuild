# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

MY_PN="${PN/-/.}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Extension module to mwlib to pull in reportlab"
HOMEPAGE="https://pediapress.com/code/ https://pypi.org/project/mwlib.ext/"
SRC_URI="$(pypi_sdist_url --no-normalize "${MY_PN}" "${PV}" .zip)"
S="${WORKDIR}/${MY_P}"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror test"

RDEPEND=">=dev-python/reportlab-2.6[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	app-arch/unzip"

PATCHES=( "${FILESDIR}/${PV}-unbundle-reportlab.patch" )
