# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 pypi virtualx

DESCRIPTION="Python interface to DBus notifications."
HOMEPAGE="https://bitbucket.org/takluyver/pynotify2"
LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="examples"
RESTRICT="mirror"

RDEPEND="dev-python/dbus-python[${PYTHON_USEDEP}]
	!<dev-python/notify2-0.3.1-r200[${PYTHON_USEDEP}]
"
BDEPEND="test? ( sys-apps/dbus[X] )"

python_test() {
	virtx ${EPYTHON} test_notify2.py
}

python_install_all() {
	if use examples; then
		rm examples/notify2.py || die
		dodoc -r examples
	fi
	distutils-r1_python_install_all
}
