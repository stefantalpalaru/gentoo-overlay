# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 python3_{10..12} )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="Modernizes Python code for eventual Python 3 migration"
HOMEPAGE="https://github.com/PyCQA/modernize"
SRC_URI="https://github.com/PyCQA/modernize/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/modernize-${PV}"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror test"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
	')
"
DEPEND="$RDEPEND"
