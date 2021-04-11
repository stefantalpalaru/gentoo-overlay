# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python client for the Advanced Message Queuing Procotol (AMQP)"
HOMEPAGE="https://barryp.org/software/py-amqplib/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tgz"

LICENSE="LGPL-3"
SLOT="python2"
KEYWORDS="amd64 ~arm64 x86"
IUSE="examples extras test"

RDEPEND="
	!<dev-python/amqplib-1.0.2-r4[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/${PN}-0.6.1_disable_socket_tests.patch"
	"${FILESDIR}/${P}-unicode_tests_py3.patch"
)

python_test() {
	"${PYTHON}" tests/client_0_8/run_all.py \
		|| die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all

	dodoc -r docs/.
	if use examples; then
		docinto examples
		dodoc -r demo/.
	fi
	if use extras; then
		insinto /usr/share/${PF}
		doins -r extras
	fi
}
