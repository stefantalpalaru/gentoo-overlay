# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi

DESCRIPTION="AMQP Messaging Framework for Python"
HOMEPAGE="https://github.com/ask/carrot/"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"
RESTRICT="mirror test"

RDEPEND="dev-python/anyjson[${PYTHON_USEDEP}]
	>=dev-python/amqplib-0.6[${PYTHON_USEDEP}]"
DEPEND="doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"
# Half of tests fail

python_compile_all() {
	use doc && emake -C docs html
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/.build/html/. )
	distutils-r1_python_install_all
}
