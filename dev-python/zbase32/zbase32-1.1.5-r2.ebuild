# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="base32 encoder/decoder (not RFC 3548 compliant)"
HOMEPAGE="https://pypi.org/project/zbase32/"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="mirror test"

RDEPEND="dev-python/pyutil[${PYTHON_USEDEP}]"
