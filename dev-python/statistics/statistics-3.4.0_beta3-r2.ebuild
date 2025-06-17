# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
MY_P=${PN}-${PV/_beta/b}

inherit distutils-r1 pypi

DESCRIPTION="A Python 2.* port of 3.4 Statistics Module"
HOMEPAGE="https://github.com/digitalemagine/py-statistics
	https://pypi.org/project/statistics/"
S=${WORKDIR}/${MY_P}
LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror"

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
