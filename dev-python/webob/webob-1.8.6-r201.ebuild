# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
MY_PN=WebOb
MY_P=${MY_PN}-${PV}
PYPI_NO_NORMALIZE=1
PYPI_PN="${MY_PN}"

inherit distutils-r1 pypi

DESCRIPTION="WSGI request and response object"
HOMEPAGE="https://webob.org/
		https://github.com/Pylons/webob"
S="${WORKDIR}/${MY_P}"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
RESTRICT="mirror test"

RDEPEND="
	!<dev-python/webob-1.8.6-r200[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs 'dev-python/alabaster'

src_prepare() {
	# py3.9
	sed -i -e 's:isAlive:is_alive:' tests/conftest.py || die
	distutils-r1_src_prepare
}
