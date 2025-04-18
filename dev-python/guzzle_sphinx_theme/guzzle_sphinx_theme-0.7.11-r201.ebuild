# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="Sphinx theme used by Guzzle"
HOMEPAGE="https://github.com/guzzle/guzzle_sphinx_theme"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=">=dev-python/sphinx-1.2[${PYTHON_USEDEP}]
	!<dev-python/guzzle_sphinx_theme-0.7.11-r200[${PYTHON_USEDEP}]
"
