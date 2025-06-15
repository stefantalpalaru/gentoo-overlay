# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="An ORM for config files"
HOMEPAGE="https://pypi.org/project/reconfigure/"
LICENSE="LGPL-3"
SLOT="python2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror"

RDEPEND="dev-python/chardet:python2[${PYTHON_USEDEP}]
	!<dev-python/reconfigure-0.1.79-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
