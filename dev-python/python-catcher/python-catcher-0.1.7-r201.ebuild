# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Beautiful stack traces for Python"
HOMEPAGE="https://pypi.org/project/python-catcher/
		http://ajenti.org/"
LICENSE="LGPL-3"
SLOT="python2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror"

RDEPEND="
	dev-python/mako:python2[${PYTHON_USEDEP}]
	dev-python/requests:python2[${PYTHON_USEDEP}]
	!<dev-python/python-catcher-0.1.7-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

python_test() {
	cd catcher || die
	"${PYTHON}" -m unittest || die
}
