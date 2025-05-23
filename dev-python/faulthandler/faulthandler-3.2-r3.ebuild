# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="functions to dump Python tracebacks explicitly (on fault, user signal, timeout)"
HOMEPAGE="https://github.com/haypo/faulthandler
		https://pypi.org/project/faulthandler/"
SRC_URI="https://github.com/vstinner/faulthandler/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
RESTRICT="mirror"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
