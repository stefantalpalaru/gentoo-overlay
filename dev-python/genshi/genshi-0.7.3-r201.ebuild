# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
DISTUTILS_USE_SETUPTOOLS=rdepend
PYPI_NO_NORMALIZE=1
PYPI_PN="${PN^}"

inherit distutils-r1 pypi

DESCRIPTION="Python toolkit for stream-based generation of output for the web"
HOMEPAGE="http://genshi.edgewall.org/
		https://github.com/edgewall/genshi
		https://pypi.org/project/Genshi/"
S="${WORKDIR}/${P^}"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="doc examples"
RESTRICT="mirror"

RDEPEND="
	!<dev-python/genshi-0.7.3-r200[${PYTHON_USEDEP}]
"

distutils_enable_tests setup.py

python_install_all() {
	if use doc; then
		dodoc doc/*.txt
	fi
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}
