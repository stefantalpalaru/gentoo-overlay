# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Config File parser for Python"
HOMEPAGE="http://cfgparse.sourceforge.net
		https://pypi.org/project/cfgparse/"
SRC_URI="$(pypi_sdist_url "${PN}" "${PV}" .zip)"
LICENSE="PSF-2.3"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="mirror test"

DEPEND="app-arch/unzip"

DOCS="README.txt docs/cfgparse.pdf"
