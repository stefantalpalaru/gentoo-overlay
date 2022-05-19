# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{8..10} )

DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1

DESCRIPTION="Modernizes Python code for eventual Python 3 migration"
HOMEPAGE="https://github.com/PyCQA/modernize"
SRC_URI="https://github.com/PyCQA/modernize/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""
RESTRICT="test"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
	')
"
DEPEND="$RDEPEND"

S="${WORKDIR}/modernize-${PV}"
