# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Draws Python object reference graphs with graphviz"
HOMEPAGE="https://mg.pov.lt/objgraph/"
SRC_URI="mirror://pypi/o/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
SLOT="python2"
IUSE="doc"

RDEPEND="media-gfx/graphviz
	!<dev-python/objgraph-3.2.0-r200[${PYTHON_USEDEP}]
"
DEPEND="dev-python/setuptools"

python_test() {
	esetup.py test
}

python_install_all() {
	use doc && local HTML_DOCS=(  docs/* )
	distutils-r1_python_install_all
}
