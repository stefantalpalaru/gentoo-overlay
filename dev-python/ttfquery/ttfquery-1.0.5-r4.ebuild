# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_PN="TTFQuery"
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

MY_PN="TTFQuery"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Font metadata and glyph outline extraction utility library"
HOMEPAGE="http://ttfquery.sourceforge.net/ https://pypi.org/project/TTFQuery/"
S="${WORKDIR}/${MY_P}"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86"

DEPEND="dev-python/fonttools
	dev-python/numpy:python2"
RDEPEND="${DEPEND}"
