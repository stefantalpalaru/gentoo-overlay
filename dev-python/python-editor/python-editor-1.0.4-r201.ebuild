# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Programmatically open an editor, capture the result."
HOMEPAGE="https://github.com/fmoo/python-editor"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 ~arm ~arm64 x86"
RESTRICT="mirror"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/six[${PYTHON_USEDEP}]
	!<dev-python/python-editor-1.0.4-r200[${PYTHON_USEDEP}]
"
