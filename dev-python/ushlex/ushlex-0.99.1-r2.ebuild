# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Replacement for shlex for Python 2.X"
HOMEPAGE="https://pypi.org/project/ushlex"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
