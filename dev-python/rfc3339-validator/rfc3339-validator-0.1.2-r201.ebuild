# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A pure python RFC3339 validator"
HOMEPAGE="https://github.com/naimetti/rfc3339-validator"
SRC_URI="https://github.com/naimetti/rfc3339-validator/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ppc ppc64 sparc x86"
RESTRICT="mirror test"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]
	dev-python/strict-rfc3339[${PYTHON_USEDEP}]
	!<dev-python/rfc3339-validator-0.1.2-r3[${PYTHON_USEDEP}]
"
