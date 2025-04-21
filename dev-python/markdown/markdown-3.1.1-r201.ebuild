# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 )
PYPI_NO_NORMALIZE=1
PYPI_PN="${PN^}"

inherit distutils-r1 pypi

DESCRIPTION="Python implementation of the markdown markup language"
HOMEPAGE="
	https://python-markdown.github.io/
	https://pypi.org/project/Markdown/
	https://github.com/Python-Markdown/markdown"
S="${WORKDIR}/${P^}"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="doc"
RESTRICT="mirror test"

# importlib_metadata is only necessary for <python:3.8 according to setup.py
RDEPEND="
	!<dev-python/markdown-3.1.1-r200[${PYTHON_USEDEP}]
"

python_prepare_all() {
	sed -i \
		-e "s/SCRIPT_NAME = 'markdown_py'/SCRIPT_NAME = 'markdown_py2'/" \
		setup.py || die
	distutils-r1_python_prepare_all
}

python_install_all() {
	use doc && dodoc -r docs/

	distutils-r1_python_install_all
}
