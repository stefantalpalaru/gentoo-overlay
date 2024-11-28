# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1

DESCRIPTION="Secure, decentralized, data store"
HOMEPAGE="https://tahoe-lafs.org/trac/tahoe-lafs"
SRC_URI="https://github.com/tahoe-lafs/tahoe-lafs/archive/${P}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-${P}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
RESTRICT="test"

RDEPEND="
	>=dev-python/characteristic-14.0.0[${PYTHON_USEDEP}]
	>=dev-python/foolscap-0.12.6[${PYTHON_USEDEP}]
	dev-python/nevow[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-0.1.8[${PYTHON_USEDEP}]
	dev-python/pyasn1-modules[${PYTHON_USEDEP}]
	dev-python/pycryptopp[${PYTHON_USEDEP}]
	dev-python/pycrypto[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.14[${PYTHON_USEDEP}]
	dev-python/pyutil[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/service-identity[${PYTHON_USEDEP}]
	dev-python/simplejson[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	>=dev-python/twisted-16.4.0[crypt,${PYTHON_USEDEP}]
	dev-python/zbase32[${PYTHON_USEDEP}]
	dev-python/zfec[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]
	net-misc/magic-wormhole[${PYTHON_USEDEP}]
"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

src_prepare() {
	rm -r setup.cfg || die
	distutils-r1_src_prepare
}

src_install() {
	distutils-r1_src_install
	use doc && dodoc -r docs/*
}
