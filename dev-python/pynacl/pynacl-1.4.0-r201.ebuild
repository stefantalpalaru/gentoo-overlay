# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
DISTUTILS_EXT=1

inherit distutils-r1

DESCRIPTION="Python binding to the Networking and Cryptography (NaCl) library"
HOMEPAGE="https://github.com/pyca/pynacl/
		https://pypi.org/project/PyNaCl/"
SRC_URI="https://github.com/pyca/${PN}/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror test"

RDEPEND="
	dev-python/six:python2[${PYTHON_USEDEP}]
	>=dev-python/cffi-1.4.1:python2[${PYTHON_USEDEP}]
	dev-libs/libsodium:0/23
	!<dev-python/pynacl-1.4.0-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

src_prepare() {
	# For not using the bundled libsodium
	export SODIUM_INSTALL=system
	sed -i -e 's:"wheel"::' setup.py || die
	distutils-r1_python_prepare_all
}
