# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN=${PN//-/_}

DESCRIPTION="WebSocket client for python with hybi13 support"
HOMEPAGE="https://github.com/websocket-client/websocket-client"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="python2"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~x64-macos"
IUSE="examples test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/six:python2[${PYTHON_USEDEP}]
	dev-python/backports-ssl-match-hostname[${PYTHON_USEDEP}]
	!<dev-python/websocket-client-0.57.0-r200[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND} )
"

S="${WORKDIR}/${MY_PN}-${PV}"

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
