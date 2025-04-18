# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1 pypi

DESCRIPTION="JOSE protocol implementation in Python"
HOMEPAGE="https://github.com/jezdez/josepy"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"
RESTRICT="mirror test"

DEPEND="
	>=dev-python/setuptools-1.0:python2[${PYTHON_USEDEP}]
	>=dev-python/cryptography-0.8:python2[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.13:python2[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0:python2[${PYTHON_USEDEP}]
	!<dev-python/josepy-1.3.0-r200[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}
	!<=app-crypt/acme-0.20.0
	!<dev-python/josepy-1.3.0-r2[${PYTHON_USEDEP}]
"

python_prepare_all() {
	sed -i \
		-e 's/jws = josepy.jws:CLI.run/jws_py2 = josepy.jws:CLI.run/' \
		setup.py || die

	distutils-r1_python_prepare_all
}
