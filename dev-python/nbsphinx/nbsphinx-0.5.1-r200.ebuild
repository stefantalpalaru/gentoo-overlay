# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Jupyter Notebook Tools for Sphinx"
HOMEPAGE="https://github.com/spatialaudio/nbsphinx/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

RDEPEND="
	dev-python/docutils:python2[${PYTHON_USEDEP}]
	dev-python/jinja:python2[${PYTHON_USEDEP}]
	dev-python/nbconvert:python2[${PYTHON_USEDEP}]
	dev-python/nbformat:python2[${PYTHON_USEDEP}]
	>=dev-python/sphinx-1.8:python2[${PYTHON_USEDEP}]
	dev-python/traitlets:python2[${PYTHON_USEDEP}]
	!<dev-python/nbsphinx-0.5.1-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
