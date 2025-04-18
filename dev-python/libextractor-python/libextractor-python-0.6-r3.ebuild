# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A library used to extract metadata from files of arbitrary type"
HOMEPAGE="https://www.gnu.org/software/libextractor/"
SRC_URI="mirror://gnu/libextractor/${P}.tar.gz"
S=${WORKDIR}/Extractor-${PV}
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
RESTRICT="mirror"

RDEPEND=">=media-libs/libextractor-0.6.3"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
