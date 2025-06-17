# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Simple settings initialization"
HOMEPAGE="https://pypi.org/project/simplesettings/"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
