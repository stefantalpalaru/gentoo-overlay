# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Script for automated searches of astronomical telescope archives"
HOMEPAGE="http://www.mpe.mpg.de/~erwin/code/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror"

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
