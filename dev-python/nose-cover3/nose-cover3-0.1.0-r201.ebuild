# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Coverage 3.x support for Nose"
HOMEPAGE="https://github.com/ask/nosecover3
		https://pypi.org/project/nose-cover3/"
LICENSE="LGPL-2"
SLOT="python2"
KEYWORDS="amd64 ~arm64 x86"
RESTRICT="mirror"

RDEPEND="dev-python/nose:python2[${PYTHON_USEDEP}]
	!<dev-python/nose-cover3-0.1.0-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
