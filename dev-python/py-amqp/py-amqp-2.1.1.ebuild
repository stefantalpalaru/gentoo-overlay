# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

MY_PN="amqp"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Low-level AMQP client for Python (fork of amqplib)"
HOMEPAGE="https://github.com/celery/py-amqp http://pypi.python.org/pypi/amqp/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples extras test"

RDEPEND=""
DEPEND="
		dev-python/setuptools[${PYTHON_USEDEP}]
		>=dev-python/vine-1.1.3[${PYTHON_USEDEP}]
		doc? (
			>=dev-python/sphinx-celery-1.1[${PYTHON_USEDEP}]
		)

		test? (
			>=dev-python/case-1.3.1[${PYTHON_USEDEP}]
			dev-python/mock[${PYTHON_USEDEP}]
			>=dev-python/pytest-3.0[${PYTHON_USEDEP}]
			dev-python/unittest2[${PYTHON_USEDEP}]
		)
		"

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	py.test -x -v || die
}

python_install_all() {
	use examples && local EXAMPLES=( demo/. )
	use doc && local HTML_DOCS=( docs/_build/html/. )
	if use extras; then
		insinto /usr/share/${PF}/extras
		doins -r extra
	fi
	distutils-r1_python_install_all
}
