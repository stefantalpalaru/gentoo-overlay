# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN=WebOb
MY_P=${MY_PN}-${PV}

DESCRIPTION="WSGI request and response object"
HOMEPAGE="https://webob.org/
		https://github.com/Pylons/webob"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
RESTRICT="test"

RDEPEND="
	!<dev-python/webob-1.8.6-r200[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs 'dev-python/alabaster'

src_prepare() {
	# py3.9
	sed -i -e 's:isAlive:is_alive:' tests/conftest.py || die
	distutils-r1_src_prepare
}
