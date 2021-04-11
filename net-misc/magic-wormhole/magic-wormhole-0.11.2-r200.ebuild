# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
EGO_PN=github.com/warner/${PN}

inherit distutils-r1

DESCRIPTION="Securely and simply transfer data between computers"
HOMEPAGE="https://github.com/warner/magic-wormhole"
KEYWORDS="~amd64"
EGIT_COMMIT="${PV}"
SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="test"

RDEPEND="
	>=dev-python/attrs-16.3.0:python2[${PYTHON_USEDEP}]
	>=dev-python/autobahn-0.14.1:python2[${PYTHON_USEDEP}]
	>=dev-python/spake2-0.8:python2[${PYTHON_USEDEP}]
	>=dev-python/tqdm-4.13.0:python2[${PYTHON_USEDEP}]
	>=dev-python/twisted-17.5.0:python2[${PYTHON_USEDEP}]
	>=dev-python/txtorcon-0.18.0.2:python2[${PYTHON_USEDEP}]
	dev-python/automat:python2[${PYTHON_USEDEP}]
	dev-python/click:python2[${PYTHON_USEDEP}]
	dev-python/hkdf:python2[${PYTHON_USEDEP}]
	dev-python/humanize:python2[${PYTHON_USEDEP}]
	dev-python/idna:python2[${PYTHON_USEDEP}]
	dev-python/pynacl:python2[${PYTHON_USEDEP}]
	dev-python/pyopenssl:python2[${PYTHON_USEDEP}]
	dev-python/service_identity:python2[${PYTHON_USEDEP}]
	dev-python/six:python2[${PYTHON_USEDEP}]
	virtual/python-futures[${PYTHON_USEDEP}]
	!<dev-python/magic-wormhole-0.11.2-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_prepare(){
	# Dirty fix because Gentoo prepends the txtorcon version number with "0.".
	# This causes version conflicts when running wormhole.
	sed -i -e 's| >= 18.0.2||' setup.py || die "Sed failed!"

	# Dirty fix because twisted-tls is not recognised as a real dependency, but
	# we made sure pyOpenSSL, service_identity and idna are built anyway.
	sed -i -e '/twisted\[tls\]/d' setup.py || die "Sed failed!"

	sed -i \
		-e 's/"wormhole = wormhole.cli.cli:wormhole"/"wormhole_py2 = wormhole.cli.cli:wormhole"/' \
		setup.py || die

	default
}
