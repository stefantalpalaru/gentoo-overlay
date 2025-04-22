# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="a Python parser that supports error recovery and round-trip parsing"
HOMEPAGE="https://github.com/davidhalter/parso
		https://pypi.org/project/parso/"
SRC_URI="https://github.com/davidhalter/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="amd64 ~arm arm64 ~ppc ppc64 x86"
RESTRICT="mirror test"

RDEPEND="
	!<dev-python/parso-0.7.1-r200[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs
