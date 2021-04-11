# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7  )

inherit distutils-r1

DESCRIPTION="Test Configuration plugin for nosetests"
HOMEPAGE="https://bitbucket.org/jnoller/nose-testconfig"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
IUSE="examples"
LICENSE="Apache-2.0"
SLOT="python2"
RESTRICT="test"

RDEPEND="dev-python/nose
	!<dev-python/nose-testconfig-0.10-r200[${PYTHON_USEDEP}]
"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DOCS=( docs/index.txt )

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
