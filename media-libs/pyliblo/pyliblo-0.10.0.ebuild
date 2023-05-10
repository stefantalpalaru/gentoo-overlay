# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1

SRC_URI="https://das.nasophon.de/download/${P}.tar.gz"
KEYWORDS="amd64 x86"

DESCRIPTION="A Python wrapper for the liblo OSC library"
HOMEPAGE="https://das.nasophon.de/pyliblo"
LICENSE="LGPL-2.1+"
SLOT="0"

DEPEND=""
RDEPEND=">=media-libs/liblo-0.27"
BDEPEND="dev-python/cython[${PYTHON_USEDEP}]"

distutils_enable_tests unittest
