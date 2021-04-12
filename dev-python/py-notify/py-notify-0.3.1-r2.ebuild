# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Tools for implementing the Observer programming pattern in Python"
HOMEPAGE="https://pypi.org/project/py-notify/"
SRC_URI="https://files.pythonhosted.org/packages/27/91/8f0760be6ea80778c155d4f2b3c7d92e3cca1047685e9048726c4bb782ec/${P}.tar.gz -> ${PF}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples test"

python_test() {
	"${PYTHON}" run-tests.py || die "Tests failed"
}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
