# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Manage external processes across test runs"
HOMEPAGE="https://pypi.org/project/pytest-xprocess/
		https://github.com/pytest-dev/pytest-xprocess"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror test"

RDEPEND="
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	!<dev-python/pytest-xprocess-0.14.0-r200[${PYTHON_USEDEP}]
"
