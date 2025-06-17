# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Strip-o-Gram HTML Conversion Library"
HOMEPAGE="https://pypi.org/project/stripogram/"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
RESTRICT="mirror"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
