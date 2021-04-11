# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="Pyro4"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Distributed object middleware for Python (RPC)"
HOMEPAGE="https://pypi.org/project/Pyro4/
	https://github.com/irmen/Pyro4"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~arm64 ~ppc ~x86"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/selectors34[${PYTHON_USEDEP}]
	>=dev-python/serpent-1.27:python2[${PYTHON_USEDEP}]
	!<dev-python/pyro-4.79-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		>=dev-python/cloudpickle-1.2.1[${PYTHON_USEDEP}]
		dev-python/dill[${PYTHON_USEDEP}]
		>=dev-python/msgpack-0.4.6[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	# Disable tests requiring network connection.
	rm tests/PyroTests/test_naming.py || die
	sed \
		-e "s/testStartNSfunc/_&/" \
		-i tests/PyroTests/test_naming2.py || die

	sed \
		-e "s/testBroadcast/_&/" \
		-e "s/testGetIP/_&/" \
		-i tests/PyroTests/test_socket.py || die

	sed -i \
		-e 's/pyro4-ns=Pyro4.naming:main/pyro4-ns_py2=Pyro4.naming:main/' \
		-e 's/pyro4-nsc=Pyro4.nsc:main/pyro4-nsc_py2=Pyro4.nsc:main/' \
		-e 's/pyro4-test-echoserver=Pyro4.test.echoserver:main/pyro4-test-echoserver_py2=Pyro4.test.echoserver:main/' \
		-e 's/pyro4-check-config=Pyro4.configuration:main/pyro4-check-config_py2=Pyro4.configuration:main/' \
		-e 's/pyro4-flameserver=Pyro4.utils.flameserver:main/pyro4-flameserver_py2=Pyro4.utils.flameserver:main/' \
		-e 's/pyro4-httpgateway=Pyro4.utils.httpgateway:main/pyro4-httpgateway_py2=Pyro4.utils.httpgateway:main/' \
		setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test
}

python_install_all() {
	use doc && HTML_DOCS=( docs/. )
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}
