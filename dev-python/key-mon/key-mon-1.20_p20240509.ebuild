# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517="setuptools"
DISTUTILS_SINGLE_IMPL=1

MY_COMMIT="26e42054fb964a1fafd6098a4ec08f65fd199b04"

inherit desktop distutils-r1 xdg-utils

DESCRIPTION="screencast utility that displays your keyboard and mouse status"
HOMEPAGE="https://github.com/scottkirkwood/key-mon"
SRC_URI="https://github.com/scottkirkwood/key-mon/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/key-mon-${MY_COMMIT}"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	$(python_gen_cond_dep '
		dev-libs/gobject-introspection[${PYTHON_SINGLE_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP},cairo]
		dev-python/python-xlib[${PYTHON_USEDEP}]
	')
"
RDEPEND="${DEPEND}"

python_install_all() {
	distutils-r1_python_install_all
	domenu icons/key-mon.desktop
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
