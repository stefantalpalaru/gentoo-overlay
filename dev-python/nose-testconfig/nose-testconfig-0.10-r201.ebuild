# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7  )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Test Configuration plugin for nosetests"
HOMEPAGE="https://bitbucket.org/jnoller/nose-testconfig"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
IUSE="examples"
RESTRICT="mirror test"

RDEPEND="dev-python/nose
	!<dev-python/nose-testconfig-0.10-r200[${PYTHON_USEDEP}]
"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DOCS=( docs/index.txt )

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
