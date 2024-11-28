# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

MY_P="${PN}-$(ver_rs 3 -)"

DESCRIPTION="WebSocket and WAMP for Twisted and Asyncio"
HOMEPAGE="https://pypi.org/project/autobahn/
	https://crossbar.io/autobahn/
	https://github.com/crossbario/autobahn-python"
S="${WORKDIR}"/${MY_P}
LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="crypt test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/cbor-1.0.0:python2[${PYTHON_USEDEP}]
	>=dev-python/lz4-0.7.0:python2[${PYTHON_USEDEP}]
	>=dev-python/py-ubjson-0.8.4:python2[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0:python2[${PYTHON_USEDEP}]
	>=dev-python/python-snappy-0.5:python2[${PYTHON_USEDEP}]
	>=dev-python/twisted-16.6.0-r2:python2[${PYTHON_USEDEP}]
	>=dev-python/txaio-2.7.0:python2[${PYTHON_USEDEP}]
	>=dev-python/u-msgpack-python-2.1:python2[${PYTHON_USEDEP}]
	>=dev-python/wsaccel-0.6.2:python2[${PYTHON_USEDEP}]
	>=dev-python/zope-interface-3.6:python2[${PYTHON_USEDEP}]
	crypt? (
		>=dev-python/pyopenssl-16.2.0:python2[${PYTHON_USEDEP}]
		>=dev-python/pynacl-1.0.1:python2[${PYTHON_USEDEP}]
		>=dev-python/pytrie-0.2:python2[${PYTHON_USEDEP}]
		>=dev-python/pyqrcode-1.1.0:python2[${PYTHON_USEDEP}]
		>=dev-python/service-identity-16.0.0:python2[${PYTHON_USEDEP}]
	)
	!<dev-python/autobahn-19.11.2-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	sed -i \
		-e 's/wamp = autobahn.__main__:_main/wamp_py2 = autobahn.__main__:_main/' \
		setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	echo "Testing all, cryptosign using twisted"
	export USE_TWISTED=true
	cd "${BUILD_DIR}"/lib || die
	py.test -v || die
	echo "RE-testing cryptosign using asyncio"
	export USE_TWISTED=false
	export USE_ASYNCIO=true
	py.test -v autobahn/wamp/test/test_cryptosign.py || die
}

pkg_postinst() {
	python_foreach_impl twisted-regen-cache || die
}

pkg_postrm() {
	python_foreach_impl twisted-regen-cache || die
}
