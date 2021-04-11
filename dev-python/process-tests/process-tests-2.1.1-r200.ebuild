# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Tools for testing processes"
HOMEPAGE="https://github.com/ionelmc/python-process-tests
		https://pypi.org/project/process-tests/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="python2"
LICENSE="BSD"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"

# There are no tests at all, under TODO
# see https://pypi.org/project/process-tests/2.0.2/
RESTRICT="test"

RDEPEND="
	!<dev-python/process-tests-2.1.1-r200[${PYTHON_USEDEP}]
"

DOCS=( README.rst )
