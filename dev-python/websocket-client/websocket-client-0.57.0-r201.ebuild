# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )
MY_PN=${PN//-/_}
PYPI_NO_NORMALIZE=1
PYPI_PN="${MY_PN}"

inherit distutils-r1 pypi

DESCRIPTION="WebSocket client for python with hybi13 support"
HOMEPAGE="https://github.com/websocket-client/websocket-client"
SRC_URI="$(pypi_sdist_url) -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"
LICENSE="LGPL-2.1"
SLOT="python2"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~x64-macos"
IUSE="examples test"
RESTRICT="mirror !test? ( test )"

RDEPEND="
	dev-python/six:python2[${PYTHON_USEDEP}]
	dev-python/backports-ssl-match-hostname[${PYTHON_USEDEP}]
	!<dev-python/websocket-client-0.57.0-r200[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND} )
"

python_prepare_all() {
	mv bin/wsdump.py bin/wsdump_py2.py
	sed -i \
		-e 's#bin/wsdump.py#bin/wsdump_py2.py#' \
		setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test
}

python_install_all() {
	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		dodoc -r examples
	fi
	distutils-r1_python_install_all
}
