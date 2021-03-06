# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Sphinx extension to automatically generate an examples gallery"
HOMEPAGE="http://sphinx-gallery.readthedocs.io/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/pytest-runner[${PYTHON_USEDEP}]
"
PDEPEND="
	$(python_gen_cond_dep 'dev-python/matplotlib-python2[${PYTHON_USEDEP}]' python2_7)
	$(python_gen_cond_dep 'dev-python/matplotlib[${PYTHON_USEDEP}]' 'python3*')
"

# tests need extra files not distributed
