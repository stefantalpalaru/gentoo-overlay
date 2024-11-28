# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Jupyter Notebook Tools for Sphinx"
HOMEPAGE="https://github.com/spatialaudio/nbsphinx/"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/docutils:python2[${PYTHON_USEDEP}]
	dev-python/jinja2:python2[${PYTHON_USEDEP}]
	dev-python/nbconvert:python2[${PYTHON_USEDEP}]
	dev-python/nbformat:python2[${PYTHON_USEDEP}]
	>=dev-python/sphinx-1.8:python2[${PYTHON_USEDEP}]
	dev-python/traitlets:python2[${PYTHON_USEDEP}]
	!<dev-python/nbsphinx-0.5.1-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
