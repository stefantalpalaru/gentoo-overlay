# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Sphinx extension to support docstrings in Numpy format"
HOMEPAGE="https://pypi.org/project/numpydoc/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="test"

RDEPEND="
	dev-python/setuptools:python2[${PYTHON_USEDEP}]
	dev-python/sphinx:python2[${PYTHON_USEDEP}]
	!<dev-python/numpydoc-0.9.2-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		>=dev-python/matplotlib-python2-1.4.0[${PYTHON_USEDEP}]
	)"

python_test() {
	esetup.py test
}
