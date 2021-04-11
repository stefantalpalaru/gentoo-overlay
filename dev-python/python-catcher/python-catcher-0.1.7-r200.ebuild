# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Beautiful stack traces for Python"
HOMEPAGE="https://pypi.org/project/python-catcher/ http://ajenti.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="python2"
LICENSE="LGPL-3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

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
