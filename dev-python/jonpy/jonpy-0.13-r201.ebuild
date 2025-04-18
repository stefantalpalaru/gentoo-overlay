# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="CGI/FastCGI/mod_python/html-templating facilities"
HOMEPAGE="http://jonpy.sourceforge.net/
		https://pypi.org/project/jonpy/"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"
RESTRICT="mirror"

RDEPEND="
	!<dev-python/jonpy-0.13-r200[${PYTHON_USEDEP}]
"

python_install_all() {
	use doc && local HTML_DOCS=( doc/. )
	use examples && local EXAMPLES=( example/. )
	distutils-r1_python_install_all
}
