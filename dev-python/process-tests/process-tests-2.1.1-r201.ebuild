# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Tools for testing processes"
HOMEPAGE="https://github.com/ionelmc/python-process-tests
		https://pypi.org/project/process-tests/"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
# There are no tests at all, under TODO
# see https://pypi.org/project/process-tests/2.0.2/
RESTRICT="mirror test"

RDEPEND="
	!<dev-python/process-tests-2.1.1-r200[${PYTHON_USEDEP}]
"

DOCS=( README.rst )
